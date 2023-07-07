tableextension 50604 Sales_inv_head_EInv extends "Sales Invoice Header"
{
    fields
    {
        field(50601; "E-Way Bill Generate"; Option)
        {
            OptionCaption = ' ,To Generate,Generated';
            OptionMembers = " ","To Generate",Generated;

        }
        field(50602; "Transport Vendor Name"; Text[50])
        {
            Caption = 'Transport Vendor Name';
            DataClassification = ToBeClassified;
        }
        field(50603; "Transport Vendor GSTIN"; Code[15])
        {
            DataClassification = ToBeClassified;
            Caption = 'DataClassification = ToBeClassified';

        }
        field(50604; "GRN Posting No"; code[20])
        {
            DataClassification = ToBeClassified;
            Editable = true;

        }
        field(50605; "GRN Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(50606; "Discrepancy Note No."; code[20])
        {
            DataClassification = ToBeClassified;
            Editable = true;
        }
        field(50607; "Discrepancy Note Date "; Date)
        {
            DataClassification = ToBeClassified;
            Editable = true;
            Caption = 'Discrepancy Note Date';
        }


    }


}