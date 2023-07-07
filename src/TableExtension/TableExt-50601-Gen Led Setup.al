tableextension 50601 Gen_Led_setup_Einv extends "General Ledger Setup"
{
    fields
    {
        field(50601; "EINV Base URL"; Text[50])
        {
            Description = 'PCPL-NSW-07';

        }
        field(50602; "EINV User Name"; Text[50])
        {
            Description = 'PCPL-NSW-07';
        }
        field(50603; "EINV Password"; Text[20])
        {
            Description = 'PCPL-NSW-07';
        }
        field(50604; "EINV Client ID"; Text[40])
        {
            Description = 'PCPL-NSW-07';
        }
        field(50605; "EINV Client Secret"; Text[40])
        {
            Description = 'PCPL-NSW-07';
        }
        field(50606; "EINV Grant Type"; Text[15])
        {
            Description = 'PCPL-NSW-07';
        }
        field(50607; "EINV Path"; Text[50])
        {
            Description = 'PCPL-NSW-07';
        }
        field(50608; "Access Token"; text[50])
        {
            Description = 'PCPL-NSW-07';
        }
        field(50609; "E-Invoice API Link"; text[250])
        {
            Description = 'PCPL-NSW-07';
        }
        field(50610; "Round of G/L Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }

    }

    var
        myInt: Integer;
}