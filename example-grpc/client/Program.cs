using System;
using System.Net.Http;
using System.Threading.Tasks;
using Grpc.Net.Client;

namespace GrpcGreeterClient
{
    class Program
    {
        static async Task Main(string[] args)
        {
            using var channel = GrpcChannel.ForAddress("https://grpc.bjdazure.tech");
            
            var client =  new Greeter.GreeterClient(channel);
            var reply = await client.SayHelloAsync( new HelloRequest { Name = "Brian" } );
            
            Console.WriteLine("Greeting: " + reply.Message);
            Console.WriteLine("Press any key to exit...");
            Console.ReadKey();
        }
    }
}
