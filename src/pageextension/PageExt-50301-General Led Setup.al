pageextension 50601 General_led_Set_Ext extends "General Ledger Setup"
{
    layout
    {
        addafter("Payroll Transaction Import")
        {
            group("E-Invoice Setup")
            {
                Caption = 'E-Invoice Setup';
                Visible = true;
                field("EINV Base URL"; rec."EINV Base URL")
                {
                    ApplicationArea = all;
                }
                field("EINV Client ID"; rec."EINV Client ID")
                {
                    ApplicationArea = all;
                }
                field("EINV Client Secret"; rec."EINV Client Secret")
                {
                    ApplicationArea = all;
                }
                field("EINV Grant Type"; rec."EINV Grant Type")
                {
                    ApplicationArea = all;
                }
                field("EINV Path"; rec."EINV Path")
                {
                    ApplicationArea = all;
                    Visible = false;
                }
                field("EINV User Name"; rec."EINV User Name")
                {
                    ApplicationArea = all;
                }
                field("EINV Password"; rec."EINV Password")
                {
                    ApplicationArea = all;
                }
                field("Access Token"; Rec."Access Token")
                {
                    ApplicationArea = all;
                }
                field("E-Invoice API Link"; Rec."E-Invoice API Link")
                {
                    ApplicationArea = all;
                    //Editable = false;
                }

            }
        }
    }

    actions
    {

    }

    var
        myInt: Integer;
}