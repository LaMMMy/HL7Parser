using HL7Parser.Models;
using NHapi.Base.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace HL7Parser.Helpers
{
    public static class ProcessHelper
    {

        /// <summary>
        /// Processes a structure group.
        /// A structure group is, primarily, a group of segments.  This could either be the entire
        /// message or special segments that need to be grouped together.  An example of this is
        /// the result segments (OBR, OBX and NTE), these are grouped together in the model
        /// definition (e.g. REF_I12_RESULTS_NOTES).
        /// </summary>
        /// <param name="structureGroup">The structure group.</param>
        /// <param name="parentNode">The parent node, in the TreeListView.</param>
        public static void ProcessStructureGroup(AbstractGroup structureGroup, FieldGroup parentNode)
        {
            foreach (string segName in structureGroup.Names)
            {
                foreach (IStructure struc in structureGroup.GetAll(segName))
                {
                    ProcessStructure(struc, parentNode);
                }
            }
        }

        /// <summary>
        /// Processes the structure.
        /// A base structure can be either a segment, or segment group. This function
        /// determines which it is before passing it on.
        /// </summary>
        /// <param name="structure">The structure.</param>
        /// <param name="parentNode">The parent node, in the TreeListView.</param>
        private static void ProcessStructure(IStructure structure, FieldGroup parentNode)
        {
            if (structure.GetType().IsSubclassOf(typeof(AbstractSegment)))
            {
                AbstractSegment seg = (AbstractSegment)structure;
                ProcessSegment(seg, parentNode);
            }
            else if (structure.GetType().IsSubclassOf(typeof(AbstractGroup)))
            {
                AbstractGroup structureGroup = (AbstractGroup)structure;
                ProcessStructureGroup(structureGroup, parentNode);
            }
            else
            {
                parentNode.FieldList.Add(new FieldGroup() { Name = "Something Else!!!" });
            }
        }

        /// <summary>
        /// Processes the segment.
        /// Loops through all of the fields within the segment, and parsing them individually.
        /// </summary>
        /// <param name="segment">The segment.</param>
        /// <param name="parentNode">The parent node.</param>
        private static void ProcessSegment(AbstractSegment segment, FieldGroup parentNode)
        {
            FieldGroup segmentNode = new FieldGroup() { Name = segment.GetStructureName(), Id = segment.GetStructureName() };
            int dataItemCount = 0;

            for (int i = 1; i <= segment.NumFields(); i++)
            {
                dataItemCount++;
                IType[] dataItems = segment.GetField(i);
                foreach (IType item in dataItems)
                {
                    ProcessField(item, segment.GetFieldDescription(i), dataItemCount.ToString(), segmentNode);
                }
            }

            AddChildGroup(parentNode, segmentNode);
        }

        /// <summary>
        /// Processes the field.
        /// Determines the type of field, before passing it onto the more specific parsing functions.
        /// </summary>
        /// <param name="item">The item.</param>
        /// <param name="fieldDescription">The field description.</param>
        /// <param name="fieldCount">The field count.</param>
        /// <param name="parentNode">The parent node.</param>
        private static void ProcessField(IType item, string fieldDescription, string fieldCount, FieldGroup parentNode)
        {
            if (item.GetType().IsSubclassOf(typeof(AbstractPrimitive)))
            {
                ProcessPrimitiveField((AbstractPrimitive)item, fieldDescription, fieldCount, parentNode);
            }
            else if (item.GetType() == typeof(Varies))
            {
                ProcessVaries((Varies)item, fieldDescription, fieldCount, parentNode);
            }
            else if (item.GetType().GetInterfaces().Contains(typeof(IComposite)))
            {
                AbstractType dataType = (AbstractType)item;
                string desc = string.IsNullOrEmpty(dataType.Description) ? fieldDescription : dataType.Description;
                ProcessCompositeField((IComposite)item, desc, fieldCount, parentNode);
            }
        }

        /// <summary>
        /// Processes the primitive field.
        /// A primitive field is the most basic type (i.e. no composite fields).  This function retrieves the data
        /// and builds the node in the TreeListView.
        /// </summary>
        /// <param name="dataItem">The data item.</param>
        /// <param name="fieldDescription">The field description.</param>
        /// <param name="fieldCount">The field count.</param>
        /// <param name="parentNode">The parent node.</param>
        private static void ProcessPrimitiveField(AbstractPrimitive dataItem, string fieldDescription, string fieldCount, FieldGroup parentNode)
        {
            string desc = fieldDescription == string.Empty ? dataItem.Description : fieldDescription;

            string typnam = System.Text.RegularExpressions.Regex.Replace(dataItem.TypeName, @"ComponentOne", @"1");

            //            desc += ":" + typnam;

            if (!string.IsNullOrEmpty(dataItem.Value))
            {
                parentNode.FieldList.Add(new FieldGroup() { Name = fieldCount.ToString() + " - " + desc, Id = parentNode.Id + "." + fieldCount, Value = "- " + dataItem.Value });
            }
        }

        /// <summary>
        /// Processes the varies.
        /// "Varies" are the data in the OBX segment, the sending application can set the type hence generically the OBX 
        /// value field is a variant type. 
        /// The "Varies" data parameter contains the data in type IType (hence being passed back to process field).
        /// </summary>
        /// <param name="varies">The varies.</param>
        /// <param name="fieldDescription">The field description.</param>
        /// <param name="fieldCount">The field count.</param>
        /// <param name="parentNode">The parent node.</param>
        private static void ProcessVaries(Varies varies, string fieldDescription, string fieldCount, FieldGroup parentNode)
        {
            ProcessField(varies.Data, fieldDescription, fieldCount, parentNode);
        }

        /// <summary>
        /// Processes the composite field.
        /// A composite field is a group of fields, such as "Coded Entry".
        /// This function breaks up the composite field and passes each field back to "ProcessField"
        /// </summary>
        /// <param name="composite">The composite.</param>
        /// <param name="fieldDescription">The field description.</param>
        /// <param name="fieldCount">The field count.</param>
        /// <param name="parentNode">The parent node.</param>
        private static void ProcessCompositeField(IComposite composite, string fieldDescription, string fieldCount, FieldGroup parentNode)
        {
            string desc = fieldDescription; // + ":" + composite.TypeName;
            FieldGroup subParent = new FieldGroup() { Name = fieldCount.ToString() + " - " + desc, Id = parentNode.Id + "." + fieldCount };

            int subItemCount = 0;
            foreach (IType subItem in composite.Components)
            {
                subItemCount++;
                ProcessField(subItem, string.Empty, subItemCount.ToString(), subParent);
            }

            AddChildGroup(parentNode, subParent);
        }

        /// <summary>
        /// Adds the child group, to the parent node, only if the child group acutally contains fields.
        /// </summary>
        /// <param name="parentNode">The parent node.</param>
        /// <param name="childGroup">The child group.</param>
        private static void AddChildGroup(FieldGroup parentNode, FieldGroup childGroup)
        {
            if (childGroup.FieldList.Count > 0)
            {
                parentNode.FieldList.Add(childGroup);
            }
        }
    }
}