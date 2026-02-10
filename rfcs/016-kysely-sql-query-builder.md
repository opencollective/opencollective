# RFC 016 - Adopting Kysely as a type-safe SQL query builder

---

# Affected projects

- [opencollective/opencollective-api](https://github.com/opencollective/opencollective-api)

# Motivation

Our current approach to writing database queries relies heavily on Sequelize's DSL — a JavaScript/TypeScript abstraction over SQL. While Sequelize has served us well for simple CRUD operations and model lifecycle management, it becomes a liability when we need to write more advanced queries:

- **Loss of control over generated SQL.** Sequelize generates SQL as it sees fit, sometimes producing different queries between `findAll` and `count` for the same logical operation. This makes it difficult to reason about performance or optimize queries.
- **No support for advanced SQL features.** CTEs, window functions, lateral joins, recursive queries, and other powerful SQL constructs are either unsupported or require escaping to raw SQL. When a developer hits the limits of the DSL, the only option is to rewrite the entire query as raw SQL.
- **Raw SQL is unsafe and untyped.** Our current escape hatch — `sequelize.query<T>(...)` — offers no query validation, no autocomplete, and relies on manual typing that is error-prone. A query like `sequelize.query<{ result: Date }>('SELECT TRUE as result')` compiles happily despite the type mismatch.
- **Query composition with raw SQL is fragile.** Complex queries that need to conditionally add joins, filters, or CTEs end up as string concatenation, which is hard to read, easy to break, and opens the door to SQL injection.
- **Thinking in Sequelize instead of SQL.** Developers are forced to reason in terms of Sequelize's API rather than SQL. This adds cognitive overhead and means that common SQL optimization patterns (like using a CTE to pre-filter before joining) are not naturally expressed.

In short: Sequelize is a great tool for what it was designed to do (model mapping, simple queries, migrations), but it is not a query builder. We need a proper query builder for the cases where SQL is the right language.

# Solution

Adopt [Kysely](https://www.kysely.dev/) as a **complementary** query builder alongside Sequelize. Kysely is a type-safe TypeScript SQL query builder with the following characteristics:

- **Pure TypeScript, zero runtime overhead.** Types are resolved at compile time; the library generates raw SQL strings at runtime with no ORM magic.
- **Syntax close to SQL.** The API reads almost like SQL, reducing the mental translation layer between what you write and what gets executed.
- **Full autocomplete and type safety.** Table names, column names, join conditions, and result types are all inferred. A typo in a column name is a compile error, not a runtime surprise.
- **Query composition.** Queries can be built incrementally (conditionally adding `.where`, `.innerJoin`, etc.) while remaining type-safe and injection-free.
- **Supports the full SQL feature set.** CTEs, subqueries, window functions, unions, lateral joins — all first-class citizens.
- **Popular and well-maintained.** Used in production by Deno, Maersk, Cal.com, and others. ~13k GitHub stars, active community.

### Integration with Sequelize via `kysely-sequelize`

Rather than introducing a second database connection pool or replacing Sequelize outright, the implementation uses [`kysely-sequelize`](https://github.com/kysely-org/kysely-sequelize) — an official bridge maintained by a Kysely core contributor. This bridge:

- **Reuses the existing Sequelize connection pool.** No additional database connections are needed.
- **Infers table types from Sequelize models.** Using `KyselifyModel`, column types are derived at compile time from existing model definitions — no manual type declarations for tables.
- **Allows gradual adoption.** Kysely and Sequelize coexist peacefully. Existing Sequelize code does not need to change.

### What the implementation provides

1. **`getKysely()`** — A singleton that returns a fully typed `Kysely<Database>` instance, ready to query any table or view.
2. **Automatic table type mapping** — Table row types are inferred from Sequelize models via `KyselifyModel`. A mapped type reads each model's `tableName` to build the complete `Database` interface.
3. **View type generation** — A script (`npm run generate:kysely-views`) introspects the database to generate TypeScript interfaces for all views and materialized views.
4. **`kyselyToSequelizeModels()`** — A helper that converts Kysely result rows back into Sequelize model instances, preserving compatibility with existing code that expects models.
5. **ESLint rule** — A custom `sequelize-model/require-table-name` rule that enforces every model declares `public static readonly tableName = 'TableName' as const;`, which is required for the type mapping to work.

### Code comparison

**Before (Sequelize raw query — no type safety, no autocomplete, no validation):**

```typescript
const [rows] = await sequelize.query<{
  tag: string;
  count: number;
  HostCollectiveId: number;
}>(
  `SELECT tag, count, "HostCollectiveId"
   FROM "CollectiveTagStats"
   WHERE tag = :tag AND "HostCollectiveId" = :hostId`,
  { replacements: { tag: "opensource", hostId: 123 }, type: QueryTypes.SELECT },
);
```

**After (Kysely — typed, validated, with autocomplete):**

```typescript
const db = getKysely();
const rows = await db
  .selectFrom("CollectiveTagStats")
  .selectAll()
  .where("tag", "=", "opensource")
  .where("HostCollectiveId", "=", 123)
  .execute();
// rows is automatically typed as CollectiveTagStatsRow[]
```

**Kysely with joins (views + tables):**

```typescript
const db = getKysely();
const rows = await db
  .selectFrom("CollectiveTagStats")
  .innerJoin(
    "Collectives",
    "Collectives.id",
    "CollectiveTagStats.HostCollectiveId",
  )
  .select([
    "CollectiveTagStats.tag",
    "CollectiveTagStats.count",
    "Collectives.slug",
  ])
  .where("CollectiveTagStats.tag", "=", "opensource")
  .execute();
// rows[0].slug is string, rows[0].count is number — all inferred
```

**Converting results back to Sequelize models when needed:**

```typescript
const db = getKysely();
const collectives = await db
  .selectFrom("Collectives")
  .selectAll()
  .where("slug", "=", "webpack")
  .execute()
  .then(kyselyToSequelizeModels(models.Collective));
// collectives[0] is a Collective model instance
```

### Drawbacks

- **Two query paradigms.** Developers need to know when to use Sequelize vs Kysely. The guideline is simple (see Adoption section), but it is still an additional concept to learn.
- **View types require regeneration.** When views are modified, `npm run generate:kysely-views` must be run. This is semi-automated and could be forgotten (though CI could enforce it).
- **New `tableName` requirement on models.** All Sequelize models must declare a `public static readonly tableName = '...' as const`. This is enforced by ESLint, and most models already had the name configured — the change is mechanical.

# Alternatives

### 1. Stay with Sequelize only

Continue using `sequelize.query()` for complex queries. This is the status quo and requires no new dependencies, but offers no type safety, no autocomplete, and fragile string concatenation for query composition.

### 2. SafeQL (ESLint plugin)

[SafeQL](https://safeql.dev/) is an ESLint plugin that validates raw SQL queries against the database schema and infers result types. It adds a safety net on top of `sequelize.query()` without introducing a new query API. A POC with SafeQL was created in https://github.com/opencollective/opencollective-api/pull/11381.

**Pros:** Works with existing raw queries, no new API to learn.
**Cons:** No query composition (still string concatenation), requires a running database for the ESLint plugin to connect to, limited IDE integration compared to Kysely's native TypeScript autocomplete.

### 3. Replace Sequelize entirely with Kysely

This would mean also using Kysely for simple CRUD, model hooks, validations, and migrations — all things Sequelize handles well today. This is not practical given the size of the codebase and would be a much larger, riskier migration with little incremental benefit. The bridge approach lets us use each tool for what it does best.

### 4. Other query builders

- **Knex:** Kysely's spiritual predecessor. Less type-safe, less active development. Kysely was explicitly designed to improve on Knex's type safety.

# Proof of concept

The implementation is available https://github.com/opencollective/opencollective-api/pull/11385. Key files:

- `server/lib/kysely.ts` — Core integration (`getKysely`, `kyselyToSequelizeModels`)
- `server/types/kysely-tables.ts` — Automatic table type mapping from Sequelize models
- `server/types/kysely-views.ts` — Auto-generated view types
- `scripts/dev/generate-kysely-view-types.ts` — View type generation script
- `eslint-rules/sequelize-model-table-name.js` — ESLint rule for `tableName`
- `test/server/lib/kysely.test.ts` — Tests demonstrating querying tables, views, joins, and model conversion

# Adoption / Transition strategy

### When to use Kysely vs Sequelize

| Use case                                                      | Tool       |
| ------------------------------------------------------------- | ---------- |
| Simple CRUD (`findOne`, `create`, `update`, `destroy`)        | Sequelize  |
| Model hooks, validations, associations                        | Sequelize  |
| Migrations                                                    | Sequelize  |
| Complex queries (joins, CTEs, subqueries, aggregations)       | **Kysely** |
| Queries currently written as raw SQL (`sequelize.query`)      | **Kysely** |
| Queries on views or materialized views                        | **Kysely** |
| Performance-sensitive queries where you need control over SQL | **Kysely** |

### Suggested steps

- [ ] Merge RFC and Kysely integration PR
- [ ] Migrate existing `sequelize.query()` calls to Kysely when touching related code (opportunistic, not a big-bang rewrite)
- [ ] Use Kysely for new complex queries going forward
- [ ] Consider adding CI check to ensure `kysely-views.ts` is up to date with the database schema

### Impact on developer experience

- **New dependency awareness:** Developers should be aware that `npm run generate:kysely-views` needs to be run when views change. This could be added to a post-migration hook or CI step.
- **Model `tableName` requirement:** Enforced by ESLint — the rule will flag any model missing the declaration. The fix is a single line addition.
- **No breaking changes:** All existing Sequelize code continues to work unchanged. Kysely is purely additive.
