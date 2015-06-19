using HL7Parser.Models;
using NHapi.Base.Model;
using System.Linq;

namespace HL7Parser.Helpers
{
    public static class ProcessHelperNew
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
        public static void ProcessStructureGroupNew(AbstractGroup structureGroup, FieldGroup parentNode)
        {
            foreach (string segName in structureGroup.Names)
            {
                foreach (IStructure struc in structureGroup.GetAll(segName))
                {
                    ProcessStructureNew(struc, parentNode);
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
        private static void ProcessStructureNew(IStructure structure, FieldGroup parentNode)
        {
            if (structure.GetType().IsSubclassOf(typeof(AbstractSegment)))
            {
                AbstractSegment seg = (AbstractSegment)structure;
                ProcessSegmentNew(seg, parentNode);
            }
            else if (structure.GetType().IsSubclassOf(typeof(AbstractGroup)))
            {
                AbstractGroup structureGroup = (AbstractGroup)structure;
                ProcessStructureGroupNew(structureGroup, parentNode);
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
        private static void ProcessSegmentNew(AbstractSegment segment, FieldGroup parentNode)
        {
            FieldGroup segmentNode = new FieldGroup() { Name = segment.GetStructureName(), Id = segment.GetStructureName() };
            int dataItemCount = 0;

            for (int i = 1; i <= segment.NumFields(); i++)
            {
                dataItemCount++;
                IType[] dataItems = segment.GetField(i);
                foreach (IType item in dataItems)
                {
                    ProcessFieldNew(item, segment.GetFieldDescription(i), dataItemCount.ToString(), segmentNode);
                }

                if (dataItems.Count() == 0 && segmentNode.FieldList.Count > 0)
                {
                    AbstractPrimitive msg = null;
                    ProcessPrimitiveFieldNew((AbstractPrimitive)msg, segment.GetFieldDescription(i), dataItemCount.ToString(), segmentNode);
                }
            }

            AddChildGroupNew(parentNode, segmentNode);
        }

        /// <summary>
        /// Processes the field.
        /// Determines the type of field, before passing it onto the more specific parsing functions.
        /// </summary>
        /// <param name="item">The item.</param>
        /// <param name="fieldDescription">The field description.</param>
        /// <param name="fieldCount">The field count.</param>
        /// <param name="parentNode">The parent node.</param>
        private static void ProcessFieldNew(IType item, string fieldDescription, string fieldCount, FieldGroup parentNode)
        {
            if (item.GetType().IsSubclassOf(typeof(AbstractPrimitive)))
            {
                ProcessPrimitiveFieldNew((AbstractPrimitive)item, fieldDescription, fieldCount, parentNode);
            }
            else if (item.GetType() == typeof(Varies))
            {
                ProcessVariesNew((Varies)item, fieldDescription, fieldCount, parentNode);
            }
            else if (item.GetType().GetInterfaces().Contains(typeof(IComposite)))
            {
                AbstractType dataType = (AbstractType)item;
                string desc = string.IsNullOrEmpty(dataType.Description) ? fieldDescription : dataType.Description;
                ProcessCompositeFieldNew((IComposite)item, desc, fieldCount, parentNode);
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
        private static void ProcessPrimitiveFieldNew(AbstractPrimitive dataItem, string fieldDescription, string fieldCount, FieldGroup parentNode)
        {
            int index = parentNode.Id.IndexOf(".");

            if (dataItem != null)
            {
                string desc = fieldDescription == string.Empty ? dataItem.Description : fieldDescription;
                string typnam = System.Text.RegularExpressions.Regex.Replace(dataItem.TypeName, @"ComponentOne", @"1");

                if (!string.IsNullOrEmpty(dataItem.Value))
                {
                    parentNode.FieldList.Add(new FieldGroup() { Name = fieldCount.ToString() + " - " + desc, Id = parentNode.Id + "." + fieldCount, Value = dataItem.Value });
                }
                else if (index == -1)
                {
                    //if (parentNode.Id.Substring(index).Length == 0)
                    //{
                    parentNode.FieldList.Add(new FieldGroup() { Name = fieldCount.ToString() + " - " + desc, Id = parentNode.Id + "." + fieldCount, Value = dataItem.Value });
                    //}
                }
            }
            else
            {
                parentNode.FieldList.Add(new FieldGroup() { Name = fieldCount.ToString() + " - " + fieldDescription, Id = parentNode.Id + "." + fieldCount, Value = string.Empty });
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
        private static void ProcessVariesNew(Varies varies, string fieldDescription, string fieldCount, FieldGroup parentNode)
        {
            ProcessFieldNew(varies.Data, fieldDescription, fieldCount, parentNode);
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
        private static void ProcessCompositeFieldNew(IComposite composite, string fieldDescription, string fieldCount, FieldGroup parentNode)
        {
            string desc = fieldDescription; // + ":" + composite.TypeName;
            FieldGroup subParent = new FieldGroup() { Name = fieldCount.ToString() + " - " + desc, Id = parentNode.Id + "." + fieldCount };

            int subItemCount = 0;
            foreach (IType subItem in composite.Components)
            {
                subItemCount++;
                ProcessFieldNew(subItem, string.Empty, subItemCount.ToString(), subParent);
            }

            AddChildGroupNew(parentNode, subParent);
        }

        /// <summary>
        /// Adds the child group, to the parent node, only if the child group acutally contains fields.
        /// </summary>
        /// <param name="parentNode">The parent node.</param>
        /// <param name="childGroup">The child group.</param>
        private static void AddChildGroupNew(FieldGroup parentNode, FieldGroup childGroup)
        {
            if (childGroup.FieldList.Count > 0)
            {
                parentNode.FieldList.Add(childGroup);
            }
        }
    }
}