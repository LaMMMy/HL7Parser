using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(HL7Parser.Startup))]
namespace HL7Parser
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
