using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HL7Parser.Models
{
    public class FieldGroup
    {
        public FieldGroup()
        {
            this.FieldList = new HashSet<FieldGroup>();
        }

        public string Id { get; set; }
        public string Name { get; set; }
        public string Value { get; set; }
        public ICollection<FieldGroup> FieldList { get; set; }
    }
}