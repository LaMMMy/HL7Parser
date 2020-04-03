using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HL7Parser
{
    public static class Extensions
    {
        /// <summary>
        /// Grabs all the innerExceptions and parses them into one string.
        /// </summary>
        /// <param name="ex"></param>
        /// <returns></returns>
        public static string GetExceptionMessageWithInner(this Exception ex) => string.Join($";{ Environment.NewLine }caused by: ", GetInnerExceptions(ex).Select(e => $"'{ e.Message }'"));

        private static IEnumerable<Exception> GetInnerExceptions(this Exception ex)
        {
            while (ex != null)
            {
                yield return ex;
                ex = ex.InnerException;
            }
        }
    }
}