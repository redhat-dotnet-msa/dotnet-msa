using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using System;
using System.Net;

namespace HelloWeb
{
    public class Startup
    {
        public void Configure(IApplicationBuilder app)
        {


            String hostname = Dns.GetHostName();

            app.Run(context =>
            {
                return context.Response.WriteAsync("The HOST running this app (VERSION 1) is named: " + hostname);
            });
        }
    }
}
