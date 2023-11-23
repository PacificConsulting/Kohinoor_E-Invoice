page 50602 "E-Way Bill Detail"
{
    // version PCPL41-EWAY

    DeleteAllowed = false;
    PageType = ListPart;
    SourceTable = 50602;
    //ApplicationArea = all;
    UsageCategory = Lists;
    Editable = true;
    //ModifyAllowed = true;

    layout
    {
        area(content)
        {
            field("Eway Bill No."; Rec."Eway Bill No.")
            {
                Editable = false;
                ApplicationArea = all;
            }
            field("Ewaybill Error"; Rec."Ewaybill Error")
            {
                ApplicationArea = all;
            }
            field("URL for PDF"; Rec."URL for PDF")
            {
                Editable = false;
                ApplicationArea = all;
            }
            field("E-Way Bill Generate"; Rec."E-Way Bill Generate")
            {
                ApplicationArea = all;
                Editable = Vedit;
            }
            field("Transporter Name"; Rec."Transporter Name")
            {
                ApplicationArea = all;
                Editable = Vedit;
                //Editable = false;
            }
            field("Transportation Mode"; Rec."Transportation Mode")
            {
                ApplicationArea = all;
                Editable = Vedit;
                //Editable = false;
            }
            field("Transport Distance"; Rec."Transport Distance")
            {
                ApplicationArea = all;
                Editable = Vedit;
                //Editable = false;
            }
            field("Transporter Id"; Rec."Transporter Id")
            {
                ApplicationArea = all;
                Editable = Vedit;
            }

        }
    }
    trigger OnAfterGetRecord()
    begin
        IF Rec."Eway Bill No." <> '' then
            Vedit := false
        else
            Vedit := true;
        //CurrPage.Editable(false);
    end;

    trigger OnOpenPage()
    begin
        IF Rec."Eway Bill No." <> '' then
            Vedit := false
        else
            Vedit := true;
    end;

    var
        Vedit: Boolean;

}

