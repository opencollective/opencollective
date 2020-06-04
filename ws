#sr
var client = new RestClient("http://example.com");
client.Authenticator = new SimpleAuthenticator("username", "foo", "password", "bar");

var request = new RestRequest("resource", Method.GET);
client.Execute(request);
