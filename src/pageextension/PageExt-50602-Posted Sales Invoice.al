pageextension 50602 "Posted_sales_Inv_ext EINV" extends "Posted Sales Invoice"
{
    // version NAVW19.00.00.48466,NAVIN9.00.00.48466
    //Old URL https://pcazureeinvoiceintegration.azurewebsites.net
    layout
    {
        modify("Your Reference")
        {
            Caption = 'Pay Reference';
        }

        addafter(General)
        {
            group("Einvoice Details")
            {
                part("E-Invoice Detail"; "E-Invoice Detail")
                {
                    SubPageLink = "Document No." = FIELD("No.");
                    ApplicationArea = all;
                }
            }
            group("E-Way Details")
            {
                part("E-Way Details1"; "E-Way Bill Detail")
                {
                    ApplicationArea = All;
                    SubPageLink = "Document No." = FIELD("No.");
                }
            }

        }


    }
    actions
    {
        modify("Generate E-Invoice")
        {
            Visible = false;
        }

        modify("Generate QR Code")
        {
            Visible = false;
        }
        modify("Import E-Invoice Response")
        {
            Visible = false;
        }
        modify("Cancel E-Invoice")
        {
            Visible = false;
        }
        modify("Generate IRN")
        {
            Visible = false;
        }
        addafter(Dimensions)
        {
            action("Generate E-Invoice New")
            {
                Enabled = true;//EINVGen;
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Caption = 'Generate E-Invoice New';


                trigger OnAction();
                var
                    token: Text;
                    result: Text;
                    transactiondetails: Text;
                    documentdetails: Text;
                    sellerdetails: Text;
                    buyerdetails: Text;
                    dispatchdetails: Text;
                    shipdetails: Text;
                    exportdetails: Text;
                    paymentdetails: Text;
                    referencedetails: Text;
                    valuedetails: Text;
                    itemlist: Text;
                    CompanyInformation: Record 79;
                    Customer: Record 18;
                    DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
                    SalesInvoiceLine: Record 113;
                    cgstrate: Integer;
                    sgstrate: Integer;
                    igstrate: Integer;
                    cessrate: Integer;
                    CGSTAmt: Decimal;
                    SGSTAmt: Decimal;
                    IGSTAmt: Decimal;
                    CESSGSTAmt: Decimal;
                    totaltaxableamt: Decimal;
                    totalcessnonadvolvalue: Decimal;
                    totalinvoicevalue: Decimal;
                    totalcessvalueofstate: Decimal;
                    totaldiscount: Decimal;
                    totalothercharge: Decimal;
                    RecLoc: Record 14;
                begin
                    //PCPL41-EINV
                    IF rec."Nature of Supply" = rec."Nature of Supply"::B2C then
                        Error('E-invoice cannot be generated for B2C customers');
                    IF RecLoc.Get(rec."Location Code") then begin
                        IF RecLoc."E-Invoice Applicable" = false then
                            Error('You do not have permission to generate E-Invoice');
                    end;
                    IF NOT CONFIRM('Do you want generate E-Invoice?') THEN
                        EXIT;
                    GenerateEInvoice;
                    //PCPL41-EINV
                end;
            }

            action("E-Way Page Open")
            {
                Image = Open;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Caption = 'Open E-way Bill Page';
                trigger OnAction()
                var
                    EwayPage: Page 50603;
                    SIH: Record 112;
                begin
                    SIH.Reset();
                    SIH.SetRange("No.", rec."No.");
                    IF SIH.FindFirst() then begin
                        EwayPage.SetTableView(SIH);
                        EwayPage.RunModal();
                    end;
                end;
            }

            action("Cancel E-Invoice New")
            {
                Enabled = EINVCan;
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;
                Caption = 'Cancel E-Invoice New';

                trigger OnAction();
                begin
                    //PCPL41-EINV
                    IF NOT CONFIRM('Do you want Cancel E-Invoice?') THEN
                        EXIT;
                    CancelEInvoice;
                    //PCPL41-EINV
                end;
            }

        }


    }

    var
        RecTSH: Record 112;
        SalesPersonName: Text[50];
        RecSP: Record 13;
        RSIH: Record 112;
        "--------------------------": Integer;
        GlobalNULL: Variant;
        bbbb: Text;
        RecLocation: Record 14;
        LRNo: Text;
        lrDate: Text;
        mont: Text;
        PDate: Text;
        Dt: Text;
        JsonString: Text;

        recGSTRegNos: Record "GST Registration Nos.";
        genledSetup: Record 98;
        signedData: Text;
        decryptedIRNResponse: Text;
        cnlrem: Text;



    local procedure GenerateEInvoice();
    var
        token: Text;
        result: Text;
        resresult: Text;
        resresult1: Text;
        resresult2: Text;
        resresult3: Text;
        resresult4: Text;
        resresult5: Text;
        resresult6: Text;
        resresultDT6: DateTime;
        NewResult3: text;
        transactiondetails: Text;
        documentdetails: Text;
        sellerdetails: Text;
        buyerdetails: Text;
        dispatchdetails: Text;
        shipdetails: Text;
        exportdetails: Text;
        paymentdetails: Text;
        referencedetails: Text;
        AddDocDetails: Text;
        valuedetails: Text;
        EwayBillDetails: Text;
        itemlist: Text;
        Document_Date: Text;
        CompanyInformation: Record 79;
        Location: Record 14;
        State: Record State;
        LocPhoneNo: Text;
        Customer: Record 18;
        BuyState: Record State;
        CustPhoneNo: Text;
        ShiptoAddress: Record 222;
        ShipState: Record State;
        GeneralLedgerSetup: Record 98;
        FileMgt: Codeunit 419;
        //TempBlob: Record 99008535;  //PCPL/NSW/030522 Not Worked in BC 19
        tempB: Record "Tenant Media";
        //<<PCPL/NSW/030522
        TempBlob1: Codeunit "Temp Blob";
        TenatMedia: Record "Tenant Media";
        Convert: Codeunit "Base64 Convert";

        Outs: OutStream;
        IntS: InStream;
        //>>PCPL/NSW/030522
        ServerFileNameTxt: Text;
        ClientFileNameTxt: Text;
        EInvoiceDetail: Record 50601;
        EINVPos: Text;
        GSTRate: Decimal;
        SalesInvoiceLine: Record 113;
        DetailedGSTLedgerEntry: Record "Detailed GST Ledger Entry";
        cgstrate: Decimal;
        sgstrate: Decimal;
        igstrate: Decimal;
        cessrate: Decimal;
        CGSTAmt: Decimal;
        SGSTAmt: Decimal;
        IGSTAmt: Decimal;
        CESSGSTAmt: Decimal;
        TotalCGSTAmt: Decimal;
        TotalSGSTAmt: Decimal;
        TotalIGSTAmt: Decimal;
        TotalCessGSTAmt: Decimal;
        totaltaxableamt: Decimal;
        totalcessnonadvolvalue: Decimal;
        totalinvoicevalue: Decimal;
        totalcessvalueofstate: Decimal;
        totaldiscount: Decimal;
        totalothercharge: Decimal;
        TotalItemValue: Decimal;
        IsService: Text;
        RoundOff: Decimal;
        SLI: Record 113;
        Item: Record 27;
        EinvState: Text;
        Natureofsupply: Text;
        ExpCustomer: Record 18;
        //<<PCPL/NSW/EINV 052522
        TaxRecordID: RecordId;
        SalesInvLineNew: Record 113;
        ComponentJobject: JsonObject;
        TCSAMTLinewise: Decimal;
        GSTBaseAmtLineWise: Decimal;
        azurefun: Codeunit "Azure Functions";
        //<<API Call Var
        client: HttpClient;
        Response: HttpResponseMessage;
        J: JsonObject;
        EinvJsonObject: JsonObject;
        ResponseTxt: Text;
        content: HttpContent;
        JsonTokenResult: Text;
        JsonEinvoiceResult: Text;
        AccessToken: Text;
        Jtoken: JsonToken;
        EinvJtoken: JsonToken;
        JsonEinvObject: JsonObject;
        EinvRequestTxt: Text;
        EinvRequestContent: HttpContent;
        EinvResponse: HttpResponseMessage;
        Einvcontent: HttpContent;
        EinvResponseTxt: Text;
        ReqOStm: OutStream;
        ReqInStm: InStream;
        ReqtempBlob: Codeunit "Temp Blob";
        FileName: text;
        HttpHead: HttpHeaders;
        QRFileName: Text;
        URLResponse: HttpResponseMessage;
        CurrencyFactor: decimal;
        //QRGenerator: Codeunit "QR Generator";
        GLSetup: Record "General Ledger Setup";

    //>>API Call Var
    //>>PCPL/NSW/EINV 052522
    begin
        //PCPL41-EINV
        //IF EInvoiceDetail.Get(Rec."No.") then
        //  Error('IRN No. is already generated for this document.');
        GLSetup.Get();
        GLSetup.TestField("Round of G/L Account");
        CLEAR(Natureofsupply);
        ExpCustomer.GET(Rec."Sell-to Customer No.");
        IF rec."GST Customer Type" = "GST Customer Type"::Export THEN BEGIN
            Natureofsupply := 'EXPWOP';
            transactiondetails := Natureofsupply + '!' + 'N' + '!' + '' + '!' + 'N';
        END ELSE
            IF ExpCustomer."GST Customer Type" = ExpCustomer."GST Customer Type"::"SEZ Unit" THEN BEGIN
                Natureofsupply := 'SEZWOP';
                transactiondetails := Natureofsupply + '!' + 'N' + '!' + '' + '!' + 'N';
            END ELSE
                transactiondetails := FORMAT(rec."Nature of Supply") + '!' + 'N' + '!' + '' + '!' + 'N';


        Document_Date := FORMAT(rec."Posting Date", 0, '<Day,2>-<Month,2>-<year4>');
        documentdetails := 'INV' + '!' + rec."No." + '!' + Document_Date;

        CompanyInformation.GET;
        IF Location.GET(rec."Location Code") then;
        State.GET(Location."State Code");
        LocPhoneNo := DELCHR(Location."Phone No.", '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)');
        LocPhoneNo := COPYSTR(LocPhoneNo, 1, 10);
        sellerdetails := Location."GST Registration No." + '!' + CompanyInformation.Name + '!' + Location.Name + '!' + DELCHR(Location.Address, '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)') + '!' + DELCHR(Location."Address 2", '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)') + '!' +
        Location.Name + '!' + DELCHR(Location."Post Code", '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)') + '!' + State."State Code (GST Reg. No.)" + '!' + LocPhoneNo + '!' + Location."E-Mail";

        dispatchdetails := Location.Name + '!' + DELCHR(Location.Address, '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)') + '!' + DELCHR(Location."Address 2", '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)') + '!' + Location.Name + '!' + Location."Post Code" + '!' + State.Description;

        Customer.GET(rec."Sell-to Customer No.");
        IF BuyState.GET(Customer."State Code") THEN
            CustPhoneNo := DELCHR(Customer."Phone No.", '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)');
        CustPhoneNo := COPYSTR(CustPhoneNo, 1, 10);
        buyerdetails := Customer."GST Registration No." + '!' + Customer.Name + '!' + Customer."Name 2" + '!' + DELCHR(Customer.Address, '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)') + '!' + DELCHR(Customer."Address 2", '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)') + '!' +
        Customer.City + '!' + DELCHR(Customer."Post Code", '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)') + '!' + BuyState."State Code (GST Reg. No.)" + '!' + BuyState.Description + '!' + CustPhoneNo + '!' +
        Customer."E-Mail";

        //PCPL 38
        IF ExpCustomer."GST Customer Type" = ExpCustomer."GST Customer Type"::Export THEN BEGIN//PCPL50 begin and else if end
            IF ExpCustomer."State Code" = '' THEN
                buyerdetails := 'URP' + '!' + Customer.Name + '!' + Customer."Name 2" + '!' + DELCHR(Customer.Address, '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)') + '!' + DELCHR(Customer."Address 2", '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)') + '!' +
                Customer.City + '!' + '999999' + '!' + '96' + '!' + '96' + '!' + CustPhoneNo + '!' +
                Customer."E-Mail";
            //PCPL 38
        END
        ELSE
            IF ExpCustomer."GST Customer Type" <> ExpCustomer."GST Customer Type"::Export THEN BEGIN //PCPL0017-21-09-2021
                SLI.RESET;
                SLI.SETRANGE("Document No.", rec."No.");
                IF SLI.FINDFIRST THEN
                    REPEAT
                        IF (SLI.Type <> SLI.Type::" ") AND (SLI.Quantity <> 0) THEN BEGIN
                            IF SLI."GST Place of Supply" = SLI."GST Place of Supply"::"Ship-to Address" THEN
                                IF rec."Ship-to Code" <> '' THEN
                                    ShiptoAddress.RESET;
                            ShiptoAddress.SETRANGE(ShiptoAddress.Code, Rec."Ship-to Code");
                            ShiptoAddress.SETRANGE(ShiptoAddress."Customer No.", Rec."Sell-to Customer No.");
                            IF ShiptoAddress.FINDFIRST THEN BEGIN
                                ShipState.GET(ShiptoAddress.State);
                                CustPhoneNo := DELCHR(ShiptoAddress."Phone No.", '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)');
                                CustPhoneNo := COPYSTR(CustPhoneNo, 1, 10);
                                buyerdetails := ShiptoAddress."GST Registration No." + '!' + ShiptoAddress.Name + '!' + ShiptoAddress."Name 2" + '!' + DELCHR(ShiptoAddress.Address, '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)') + '!' + DELCHR(ShiptoAddress."Address 2", '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)') + '!' +
                                ShiptoAddress.City + '!' + DelChr(ShiptoAddress."Post Code", '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)') + '!' + ShipState."State Code (GST Reg. No.)" + '!' + ShipState.Description + '!' + CustPhoneNo + '!' +
                                ShiptoAddress."E-Mail";
                            END;
                        END;
                    UNTIL SLI.NEXT = 0;
            END;  //PCPL50 begin and else if end
                  /*
                  Customer.GET("Sell-to Customer No.");
                  BuyState.GET(Customer."State Code");
                  CustPhoneNo := DELCHR(Customer."Phone No.",'=','!|@|#|$|%|^|&|*|/|''|\|-| |(|)');
                  buyerdetails := Customer."GST Registration No."+'!'+Customer.Name+'!'+Customer."Name 2"+'!'+Customer.Address+'!'+Customer."Address 2"+'!'+
                  Customer.City+'!'+Customer."Post Code"+'!'+BuyState."State Code (GST Reg. No.)"+'!'+BuyState.Description+'!'+CustPhoneNo+'!'+
                  Customer."E-Mail";
                  */
                  //PCPL0017-21-09-2021
        IF (ExpCustomer."GST Customer Type" = ExpCustomer."GST Customer Type"::Export) THEN BEGIN //PCPL0017-21-09-2021
            shipdetails := 'URP' + '!' + Customer.Name + '!' + Customer."Name 2" + '!' + DELCHR(Customer.Address, '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)') + '!' + DELCHR(Customer."Address 2", '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)') + '!' +
            Customer.City + '!' + '999999' + '!' + '96';
        END ELSE //PCPL50 begin and else if end
            IF (ExpCustomer."GST Customer Type" <> ExpCustomer."GST Customer Type"::Export) THEN BEGIN //PCPL0017-21-09-2021
                IF rec."Ship-to Code" <> '' THEN BEGIN
                    ShiptoAddress.RESET;
                    ShiptoAddress.SETRANGE(ShiptoAddress.Code, rec."Ship-to Code");
                    ShiptoAddress.SETRANGE(ShiptoAddress."Customer No.", rec."Sell-to Customer No.");
                    IF ShiptoAddress.FINDFIRST THEN BEGIN
                        ShipState.GET(ShiptoAddress.State);
                        shipdetails := ShiptoAddress."GST Registration No." + '!' + ShiptoAddress.Name + '!' + ShiptoAddress."Name 2" + '!' + DELCHR(ShiptoAddress.Address, '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)') + '!' +
                        DELCHR(ShiptoAddress."Address 2", '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)') + '!' + ShiptoAddress.City + '!' + ShiptoAddress."Post Code" + '!' + ShipState.Description;
                    END
                END;
            END;//PCPL50 begin and else if end
        //PCPL0017-21-09-2021
        exportdetails := '';
        paymentdetails := '';
        referencedetails := '';
        AddDocDetails := '';
        EwayBillDetails := '';

        CLEAR(TotalCGSTAmt);
        CLEAR(TotalSGSTAmt);
        CLEAR(TotalIGSTAmt);
        CLEAR(TotalCessGSTAmt);
        CLEAR(totaltaxableamt);
        CLEAR(totalcessnonadvolvalue);
        CLEAR(totalinvoicevalue);
        CLEAR(totalcessvalueofstate);
        CLEAR(totaldiscount);
        CLEAR(totalothercharge);
        CLEAR(itemlist);
        Clear(TaxRecordID);
        Clear(TCSAMTLinewise);//PCPL/NSW/EINV 050522
        CLear(GSTBaseAmtLineWise);//PCPL/NSW/EINV 050522

        SalesInvoiceLine.RESET;
        SalesInvoiceLine.SETCURRENTKEY("Document No.");
        SalesInvoiceLine.SETRANGE("Document No.", rec."No.");
        SalesInvoiceLine.SETFILTER(Type, '<>%1', SalesInvoiceLine.Type::" ");
        SalesInvoiceLine.SETFILTER(Quantity, '<>%1', 0);
        //SalesInvoiceLine.SETFILTER(SalesInvoiceLine."Unit of Measure Code",'<>%1','');
        IF SalesInvoiceLine.FINDSET THEN
            REPEAT
                CLEAR(CGSTAmt);
                CLEAR(SGSTAmt);
                CLEAR(IGSTAmt);
                CLEAR(CESSGSTAmt);
                CLEAR(cgstrate);
                CLEAR(sgstrate);
                CLEAR(igstrate);
                CLEAR(cessrate);
                Clear(TCSAMTLinewise);//PCPL/NSW/EINV 050522
                Clear(GSTBaseAmtLineWise); //PCPL/NSW/EINV 050522


                IF (rec."Currency Code" = '') THEN BEGIN//PCPL50
                    DetailedGSTLedgerEntry.RESET;
                    DetailedGSTLedgerEntry.SETCURRENTKEY("Transaction Type", "Document Type", "Document No.", "Document Line No.");
                    DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
                    DetailedGSTLedgerEntry.SETRANGE("Document No.", SalesInvoiceLine."Document No.");
                    DetailedGSTLedgerEntry.SETRANGE("Document Line No.", SalesInvoiceLine."Line No.");
                    IF DetailedGSTLedgerEntry.FINDSET THEN
                        REPEAT
                            IF DetailedGSTLedgerEntry."GST Component Code" = 'CGST' THEN BEGIN
                                CGSTAmt := ABS(DetailedGSTLedgerEntry."GST Amount");
                                cgstrate := ABS(DetailedGSTLedgerEntry."GST %");
                            END ELSE
                                IF (DetailedGSTLedgerEntry."GST Component Code" = 'SGST') OR (DetailedGSTLedgerEntry."GST Component Code" = 'UTGST') THEN BEGIN
                                    SGSTAmt := ABS(DetailedGSTLedgerEntry."GST Amount");
                                    sgstrate := ABS(DetailedGSTLedgerEntry."GST %");
                                END ELSE
                                    IF DetailedGSTLedgerEntry."GST Component Code" = 'IGST' THEN BEGIN
                                        IGSTAmt := ABS(DetailedGSTLedgerEntry."GST Amount");
                                        igstrate := ABS(DetailedGSTLedgerEntry."GST %");
                                    END ELSE
                                        IF DetailedGSTLedgerEntry."GST Component Code" = 'CESS' THEN BEGIN
                                            CESSGSTAmt := ABS(DetailedGSTLedgerEntry."GST Amount");
                                            cessrate := DetailedGSTLedgerEntry."GST %";
                                        END;
                        UNTIL DetailedGSTLedgerEntry.NEXT = 0;

                    CLEAR(GSTRate);
                    IF (CGSTAmt <> 0) AND (SGSTAmt <> 0) THEN
                        GSTRate := cgstrate + sgstrate;
                    IF IGSTAmt <> 0 THEN
                        GSTRate := igstrate;
                    IF CESSGSTAmt <> 0 THEN
                        GSTRate := cessrate;

                    /* <<PCPL/NSW/030522
                    IF SalesInvoiceLine."GST Base Amount" = 0 THEN
                        totaltaxableamt += SalesInvoiceLine.Amount
                    ELSE
                        totaltaxableamt += SalesInvoiceLine."GST Base Amount";
                     //PCPL/NSW/030522 */

                    //<<PCPL/NSW/030522     
                    IF SalesInvoiceLine."Line Amount" = 0 then
                        totaltaxableamt += SalesInvoiceLine.Amount
                    ELSE
                        totaltaxableamt += SalesInvoiceLine."Line Amount";
                    //>>PCPL/NSW/030522     


                    TotalCGSTAmt += CGSTAmt;
                    TotalSGSTAmt += SGSTAmt;
                    TotalIGSTAmt += IGSTAmt;
                    TotalCessGSTAmt += CESSGSTAmt;
                    //<<PCPL/NSW/EINV 052522
                    if SalesInvLineNew.Get(SalesInvoiceLine."Document No.", SalesInvoiceLine."Line No.") then
                        TaxRecordID := SalesInvLineNew.RecordId();
                    TCSAMTLinewise := GetTcsAmtLineWise(TaxRecordID, ComponentJobject);
                    GSTBaseAmtLineWise := GetGSTBaseAmtLineWise(TaxRecordID, ComponentJobject);
                    //>>PCPL/NSW/EINV 052522

                    totalcessnonadvolvalue += 0;
                    TotalItemValue := SalesInvoiceLine."Line Amount" + CGSTAmt + SGSTAmt + IGSTAmt + CESSGSTAmt + TCSAMTLinewise;//SalesInvoiceLine."TDS/TCS Amount"; //PCPL/NSW/EINV 052522
                    totalinvoicevalue += SalesInvoiceLine."Line Amount" + CGSTAmt + SGSTAmt + IGSTAmt + CESSGSTAmt + TCSAMTLinewise;// SalesInvoiceLine."TDS/TCS Amount"; //PCPL/NSW/EINV 052522
                    totalcessvalueofstate += 0;
                    IF SalesInvoiceLine."No." = '400003' then
                        totaldiscount += SalesInvoiceLine.Amount
                    else
                        totaldiscount += SalesInvoiceLine."Line Discount Amount";
                    totalothercharge += 0;//SalesInvoiceLine."Charges To Customer"; //PCPL/NSW/030522 Code commented for Temp field not Exist in BC18
                END
                //  PCPL50 begin
                ELSE
                    IF (rec."Currency Code" <> '') OR (ExpCustomer."GST Customer Type" = ExpCustomer."GST Customer Type"::Export) THEN BEGIN
                        DetailedGSTLedgerEntry.RESET;
                        DetailedGSTLedgerEntry.SETCURRENTKEY("Transaction Type", "Document Type", "Document No.", "Document Line No.");
                        DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
                        DetailedGSTLedgerEntry.SETRANGE("Document No.", SalesInvoiceLine."Document No.");
                        DetailedGSTLedgerEntry.SETRANGE("Document Line No.", SalesInvoiceLine."Line No.");
                        IF DetailedGSTLedgerEntry.FINDSET THEN
                            REPEAT
                                IF DetailedGSTLedgerEntry."GST Component Code" = 'CGST' THEN BEGIN
                                    CGSTAmt := ABS(DetailedGSTLedgerEntry."GST Amount" / rec."Currency Factor");
                                    cgstrate := ABS(DetailedGSTLedgerEntry."GST %" / rec."Currency Factor");
                                END ELSE
                                    IF (DetailedGSTLedgerEntry."GST Component Code" = 'SGST') OR (DetailedGSTLedgerEntry."GST Component Code" = 'UTGST') THEN BEGIN
                                        SGSTAmt := ABS(DetailedGSTLedgerEntry."GST Amount" / rec."Currency Factor");
                                        sgstrate := ABS(DetailedGSTLedgerEntry."GST %" / rec."Currency Factor");
                                    END ELSE
                                        IF DetailedGSTLedgerEntry."GST Component Code" = 'IGST' THEN BEGIN
                                            IGSTAmt := ABS(DetailedGSTLedgerEntry."GST Amount" / rec."Currency Factor");
                                            igstrate := ABS(DetailedGSTLedgerEntry."GST %" / rec."Currency Factor");
                                        END ELSE
                                            IF DetailedGSTLedgerEntry."GST Component Code" = 'CESS' THEN BEGIN
                                                CESSGSTAmt := ABS(DetailedGSTLedgerEntry."GST Amount" / rec."Currency Factor");
                                                cessrate := (DetailedGSTLedgerEntry."GST %" / rec."Currency Factor");
                                            END;
                            UNTIL DetailedGSTLedgerEntry.NEXT = 0;

                        CLEAR(GSTRate);
                        IF (CGSTAmt <> 0) AND (SGSTAmt <> 0) THEN
                            GSTRate := ((cgstrate + sgstrate) / rec."Currency Factor");
                        IF IGSTAmt <> 0 THEN
                            GSTRate := (igstrate / rec."Currency Factor");
                        IF CESSGSTAmt <> 0 THEN
                            GSTRate := (cessrate / rec."Currency Factor");

                        //IF SalesInvoiceLine."GST Base Amount" = 0 THEN //PCPL/NSW/EINV 052522  Old Code Comment field not Exist in BC 19
                        IF GSTBaseAmtLineWise = 0 then //PCPL/NSW/EINV 052522 New Code Added
                            totaltaxableamt += (SalesInvoiceLine.Amount / rec."Currency Factor")
                        ELSE
                            totaltaxableamt += (GSTBaseAmtLineWise / rec."Currency Factor"); //PCPL/NSW/EINV 052522 New Code Added
                                                                                             //totaltaxableamt += (SalesInvoiceLine."GST Base Amount" / "Currency Factor"); //PCPL/NSW/EINV 052522  Old Code Comment field not Exist in BC 19

                        TotalCGSTAmt += (CGSTAmt / rec."Currency Factor");
                        TotalSGSTAmt += (SGSTAmt / rec."Currency Factor");
                        TotalIGSTAmt += (IGSTAmt / rec."Currency Factor");
                        TotalCessGSTAmt += (CESSGSTAmt / rec."Currency Factor");

                        totalcessnonadvolvalue += 0;
                        TotalItemValue := ((SalesInvoiceLine."Line Amount" + CGSTAmt + SGSTAmt + IGSTAmt + CESSGSTAmt + TCSAMTLinewise) / rec."Currency Factor"); //PCPL/NSW/EINV 050522
                        totalinvoicevalue += ((SalesInvoiceLine."Line Amount" + CGSTAmt + SGSTAmt + IGSTAmt + CESSGSTAmt + TCSAMTLinewise) / rec."Currency Factor"); //PCPL/NSW/EINV 050522
                        totalcessvalueofstate += 0;
                        if SalesInvoiceLine."No." = '400003' then
                            totaldiscount += (SalesInvoiceLine.Amount / rec."Currency Factor")
                        else
                            totaldiscount += (SalesInvoiceLine."Line Discount Amount" / rec."Currency Factor");
                        totalothercharge += 0;// (SalesInvoiceLine."Charges To Customer" / "Currency Factor"); //PCPL/NSW/EINV 052522  Old Code Comment field not Exist in BC 19
                    END;
                //PCPL50 end

                IF SalesInvoiceLine."GST Group Type" = SalesInvoiceLine."GST Group Type"::Service THEN
                    IsService := 'Y'
                ELSE
                    IF SalesInvoiceLine."GST Group Type" = SalesInvoiceLine."GST Group Type"::Goods THEN
                        IsService := 'N';

                IF SalesInvoiceLine.Type = SalesInvoiceLine.Type::Item THEN
                    Item.GET(SalesInvoiceLine."No.");

                /*
                IF SalesInvoiceLine."Unit of Measure Code" = 'BL' THEN
                  UOM := 'OTH'
                ELSE IF SalesInvoiceLine."Unit of Measure Code" = 'KG' THEN
                  UOM := 'KGS'
                ELSE IF SalesInvoiceLine."Unit of Measure Code" = 'MT' THEN
                  UOM := 'MTS'
                ELSE
                  UOM := SalesInvoiceLine."Unit of Measure Code";
                */
                IF rec."Currency Code" = '' THEN BEGIN //PCPL50
                    CLEAR(RoundOff);
                    IF SalesInvoiceLine."No." = GLSetup."Round of G/L Account" THEN
                        RoundOff := SalesInvoiceLine."Line Amount";
                END
                //PCPL50 begin
                ELSE
                    IF (rec."Currency Code" <> '') OR (ExpCustomer."GST Customer Type" = ExpCustomer."GST Customer Type"::Export) THEN BEGIN
                        CLEAR(RoundOff);
                        IF SalesInvoiceLine."No." = GLSetup."Round of G/L Account" THEN
                            RoundOff := (SalesInvoiceLine."Line Amount" / rec."Currency Factor");
                    END;
                //PCPL50 end
                // IF SalesInvoiceLine.Type=SalesInvoiceLine.Type::Item then


                //
                IF rec."Currency Factor" = 0 then
                    CurrencyFactor := 1
                else
                    CurrencyFactor := rec."Currency Factor";

                IF (ExpCustomer."GST Customer Type" <> ExpCustomer."GST Customer Type"::Export) THEN BEGIN //PCPL50
                    IF (itemlist = '') AND (SalesInvoiceLine."No." <> GLSetup."Round of G/L Account") THEN
                        itemlist := FORMAT(SalesInvoiceLine."Line No.") + '!' + DELCHR(FORMAT(Item."Description 2"), '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)|®|™') + '!' + IsService + '!' + SalesInvoiceLine."HSN/SAC Code" + '!' + '' + '!' +
                        FORMAT(SalesInvoiceLine.Quantity) + '!' + '' + '!' + SalesInvoiceLine."Unit of Measure Code" + '!' + FORMAT(ROUND(SalesInvoiceLine."Unit Price", 0.01, '>')) + '!' +
                        FORMAT(ROUND(SalesInvoiceLine."Unit Price", 0.01, '>') * (SalesInvoiceLine.Quantity)/*SalesInvoiceLine."Line Amount"*/) + '!' + '0' + '!' + FORMAT(SalesInvoiceLine."Line Discount Amount") + '!' + FORMAT(TCSAMTLinewise) +
                        '!' + FORMAT(GSTBaseAmtLineWise/*SalesInvoiceLine."Tax Base Amount"*/) + '!' +/*FORMAT(ROUND(SalesInvoiceLine."GST %",1,'='))*/FORMAT(GSTRate) + '!' + FORMAT(IGSTAmt) + '!' + FORMAT(CGSTAmt) + '!' +
                        FORMAT(SGSTAmt) + '!' + FORMAT(cessrate) + '!' + FORMAT(CESSGSTAmt) + '!' + '0' + '!' + '0' + '!' + '0' + '!' + '0' + '!' + FORMAT(TotalItemValue) +
                        '!' + '' + '!' + '' + '!' + '' + '!' + '' + '!' + '' + '!' + '' + '' + '!' + ''
                    ELSE
                        IF SalesInvoiceLine."No." <> GLSetup."Round of G/L Account" THEN
                            itemlist := itemlist + ';' + FORMAT(SalesInvoiceLine."Line No.") + '!' + DELCHR(FORMAT(Item."Description 2"), '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)|®|™') + '!' + IsService + '!' + SalesInvoiceLine."HSN/SAC Code" +
                            '!' + '' + '!' + FORMAT(SalesInvoiceLine.Quantity) + '!' + '' + '!' + SalesInvoiceLine."Unit of Measure Code" + '!' +
                            FORMAT(ROUND(SalesInvoiceLine."Unit Price", 0.01, '>')) + '!' + FORMAT(ROUND(SalesInvoiceLine."Unit Price", 0.01, '>') * (SalesInvoiceLine.Quantity)/*SalesInvoiceLine."Line Amount"*/) + '!' + '0' + '!' +
                            FORMAT(SalesInvoiceLine."Line Discount Amount") + '!' + FORMAT(TCSAMTLinewise) + '!' + FORMAT(GSTBaseAmtLineWise/*SalesInvoiceLine."Tax Base Amount"*/) + '!' +
                            /*FORMAT(ROUND(SalesInvoiceLine."GST %",1,'='))*/FORMAT(GSTRate) + '!' + FORMAT(IGSTAmt) + '!' + FORMAT(CGSTAmt) + '!' + FORMAT(SGSTAmt) + '!' + FORMAT(cessrate) + '!' +
                            FORMAT(CESSGSTAmt) + '!' + '0' + '!' + '0' + '!' + '0' + '!' + '0' + '!' + FORMAT(TotalItemValue) + '!' + '' + '!' + '' + '!' + '' + '!' + '' + '!' + '' + '!' + '' +
                            '' + '!' + ''
                END
                ELSE
                    IF (rec."Currency Code" <> '') OR (ExpCustomer."GST Customer Type" = ExpCustomer."GST Customer Type"::Export) THEN BEGIN
                        IF (itemlist = '') AND (SalesInvoiceLine."No." <> GLSetup."Round of G/L Account") THEN
                            itemlist := FORMAT(SalesInvoiceLine."Line No.") + '!' + DELCHR(FORMAT(Item.Description), '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)|®|™') + '!' + IsService + '!' + SalesInvoiceLine."HSN/SAC Code" + '!' + '' + '!' +
                            FORMAT(SalesInvoiceLine.Quantity) + '!' + '' + '!' + SalesInvoiceLine."Unit of Measure Code" + '!' + FORMAT(ROUND((SalesInvoiceLine."Unit Price" / CurrencyFactor), 0.01, '>')) + '!' +
                            FORMAT((ROUND(SalesInvoiceLine."Unit Price", 0.01, '>') * (SalesInvoiceLine.Quantity)) / CurrencyFactor) + '!' + '0' + '!' + FORMAT(SalesInvoiceLine."Line Discount Amount" / CurrencyFactor) + '!' + FORMAT(TCSAMTLineWise / CurrencyFactor) +
                            '!' + FORMAT(GSTBaseAmtLineWise/*SalesInvoiceLine."Tax Base Amount" / "Currency Factor"*/) + '!' +/*FORMAT(ROUND(SalesInvoiceLine."GST %",1,'='))*/FORMAT(GSTRate) + '!' + FORMAT(IGSTAmt) + '!' + FORMAT(CGSTAmt) + '!' +
                            FORMAT(SGSTAmt) + '!' + FORMAT(cessrate) + '!' + FORMAT(CESSGSTAmt) + '!' + '0' + '!' + '0' + '!' + '0' + '!' + '0' + '!' + FORMAT(TotalItemValue) +
                            '!' + '' + '!' + '' + '!' + '' + '!' + '' + '!' + '' + '!' + '' + '' + '!' + ''
                        ELSE
                            IF SalesInvoiceLine."No." <> GLSetup."Round of G/L Account" THEN
                                itemlist := itemlist + ';' + FORMAT(SalesInvoiceLine."Line No.") + '!' + DELCHR(FORMAT(Item.Description), '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)|®|™') + '!' + IsService + '!' + SalesInvoiceLine."HSN/SAC Code" +
                                '!' + '' + '!' + FORMAT(SalesInvoiceLine.Quantity) + '!' + '' + '!' + SalesInvoiceLine."Unit of Measure Code" + '!' +
                                FORMAT(ROUND((SalesInvoiceLine."Unit Price" / CurrencyFactor), 0.01, '>')) + '!' + FORMAT((ROUND(SalesInvoiceLine."Unit Price", 0.01, '>') * (SalesInvoiceLine.Quantity)) / CurrencyFactor) + '!' + '0' + '!' +
                                FORMAT(SalesInvoiceLine."Line Discount Amount" / CurrencyFactor) + '!' + FORMAT(TCSAMTLinewise / CurrencyFactor) + '!' + FORMAT(GSTBaseAmtLineWise / CurrencyFactor) + '!' +
                                /*FORMAT(ROUND(SalesInvoiceLine."GST %",1,'='))*/FORMAT(GSTRate) + '!' + FORMAT(IGSTAmt) + '!' + FORMAT(CGSTAmt) + '!' + FORMAT(SGSTAmt) + '!' + FORMAT(cessrate) + '!' +
                                FORMAT(CESSGSTAmt) + '!' + '0' + '!' + '0' + '!' + '0' + '!' + '0' + '!' + FORMAT(TotalItemValue) + '!' + '' + '!' + '' + '!' + '' + '!' + '' + '!' + '' + '!' + '' +
                                '' + '!' + ''
                    END;
            UNTIL SalesInvoiceLine.NEXT = 0;

        valuedetails := FORMAT(totaltaxableamt) + '!' + FORMAT(TotalCGSTAmt) + '!' + FORMAT(TotalCGSTAmt) + '!' + FORMAT(TotalIGSTAmt) + '!' + FORMAT(TotalCessGSTAmt) + '!' +
        FORMAT(totalcessnonadvolvalue) + '!' + FORMAT(totalinvoicevalue) + '!' + FORMAT(totalcessvalueofstate) + '!' + FORMAT(RoundOff) + '!' + '0' + '!' + FORMAT(totaldiscount) + '!' +
        FORMAT(totalothercharge);



        //api code
        /*
        JsonTokenResult := GetTokenRequest();
        //Message(JsonTokenResult);
        if client.Get('https://pcazureeinvoiceintegrationuat.azurewebsites.net/api/GetToken' + JsonTokenResult, Response) then begin
            if Response.IsSuccessStatusCode() then begin
                content := Response.Content;
                content.ReadAs(ResponseTxt);
                J.ReadFrom(ResponseTxt);
                J.Get('access_token', Jtoken);
                AccessToken := Jtoken.AsValue().AsText();
            end;
            // else
            //     Message('msg %1', Response.HttpStatusCode);
        end;
        */
        //MESSAGE(AccessToken);


        // GeneralLedgerSetup.GET;
        // EInvGT := EInvGT.TokenController;
        // token := EInvGT.GetToken(GeneralLedgerSetup."EINV Base URL", GeneralLedgerSetup."EINV User Name", GeneralLedgerSetup."EINV Password",
        // GeneralLedgerSetup."EINV Client ID", GeneralLedgerSetup."EINV Client Secret", GeneralLedgerSetup."EINV Grant Type");
        // MESSAGE(token);

        //*********Start

        // JsonEinvObject.Add('baseURL', 'https://clientbasic.mastersindia.co');
        // JsonEinvObject.Add('access_token', '67118f6bfaa1efedba09c90f9b2bc578e70f8468');
        // JsonEinvObject.Add('user_gstin', '09AAAPG7885R002');
        // JsonEinvObject.Add('data_source', 'erp');
        // JsonEinvObject.Add('transaction_details', 'B2B!N!!N');
        // JsonEinvObject.Add('document_details', 'INV!TIL/SIN/18-19/02!22-09-2020');
        // JsonEinvObject.Add('seller_details', '09AAAPG7885R002!TRIMULA INDUSTRIES LIMITED!!Vill. \u0026 Post-Gondwali!Tehsil-Devassar,!SINGRAULI!221003!09!9876543232!!');
        // JsonEinvObject.Add('buyer_details', '05AAAPG788R002!TRIMULA INDUSTRIES LIMITED!!Vill. \u0026 Post-Gondwali!Tehsil-Devassar,!SINGRAULI!110002!05!09!9876543232!!');
        // JsonEinvObject.Add('dispatch_details', 'TRIMULA!Vill!Tehsil!SINGRAULI!486892!Madhya Pradesh');
        // JsonEinvObject.Add('ship_details', '05AAAPG7885R002!Devbhoomi!!D10!Bahadrabad!SINGRAULI!248001!Uttarakhand');
        // JsonEinvObject.Add('export_details', '');
        // JsonEinvObject.Add('payment_details', '');
        // JsonEinvObject.Add('reference_details', '');
        // JsonEinvObject.Add('additional_document_details', '');
        // JsonEinvObject.Add('value_details', '632156!0!0!113788!0!0!745944!0!0!0!0!0');
        // JsonEinvObject.Add('ewaybill_details', '');
        // JsonEinvObject.Add('item_list', '20000!Sponge Iron Lumps!N!1001!!29.96!0!PCS!21100!632156!0!0!0!632156!18!113788!0!0!0!0!0!0!0!0!745944!!!!!!22-09-2020');
        // JsonEinvObject.Add('document_no', 'TIL/SIN/18-19/02');

        //*********End
        //JsonEinvoiceResult:=GetEinvoiceRequest();
        GeneralLedgerSetup.get();
        // AccessToken := '67118f6bfaa1efedba09c90f9b2bc578e70f8468';
        JsonEinvObject.Add('baseURL', GeneralLedgerSetup."EINV Base URL");
        JsonEinvObject.Add('access_token', GeneralLedgerSetup."Access Token");
        JsonEinvObject.Add('user_gstin', Location."GST Registration No.");
        JsonEinvObject.Add('data_source', 'erp');
        JsonEinvObject.Add('transaction_details', transactiondetails);
        JsonEinvObject.Add('document_details', documentdetails);
        JsonEinvObject.Add('seller_details', sellerdetails);
        JsonEinvObject.Add('buyer_details', buyerdetails);
        JsonEinvObject.Add('dispatch_details', dispatchdetails);
        JsonEinvObject.Add('ship_details', shipdetails);
        JsonEinvObject.Add('export_details', exportdetails);
        JsonEinvObject.Add('payment_details', paymentdetails);
        JsonEinvObject.Add('reference_details', referencedetails);
        JsonEinvObject.Add('additional_document_details', AddDocDetails);
        JsonEinvObject.Add('value_details', valuedetails);
        JsonEinvObject.Add('ewaybill_details', EwayBillDetails);
        JsonEinvObject.Add('item_list', itemlist);
        JsonEinvObject.Add('document_no', rec."No.");

        JsonEinvObject.WriteTo(EinvRequestTxt);
        EinvRequestTxt := EinvRequestTxt.Replace('}}', '}');
        EinvRequestContent.WriteFrom(EinvRequestTxt);
        EinvRequestContent.GetHeaders(HttpHead);



        //<<************Request File Download code*************
        FileName := rec."No." + '_' + 'Requestfile' + '.txt';
        reqtempblob.CreateInStream(reqInStm);
        reqtempblob.CreateOutStream(reqOStm);
        JsonEinvObject.WriteTo(reqOStm);
        reqOStm.WriteText(EinvRequestTxt);
        reqInStm.ReadText(EinvRequestTxt);
        DownloadFromStream(ReqInStm, '', '', '', FileName);
        //clear(ReqtempBlob);//231122
        //Message('File Download Request');
        //>>************Request File Download code*************
        //if client.Post('https://pcazureeinvoiceintegrationuat.azurewebsites.net/api/GenerateIRN', EinvRequestContent, EinvResponse) then begin
        if client.Post(GeneralLedgerSetup."E-Invoice API Link", EinvRequestContent, EinvResponse) then begin
            if EinvResponse.IsSuccessStatusCode() then begin
                Einvcontent := EinvResponse.Content;
                Einvcontent.ReadAs(result);
                EINVPos := COPYSTR(result, 1, 8);

                IF EINVPos = 'SUCCESS;' THEN BEGIN
                    resresult := CONVERTSTR(result, ';', ',');
                    resresult1 := SELECTSTR(1, resresult);
                    resresult2 := SELECTSTR(2, resresult);
                    resresult3 := SELECTSTR(3, resresult);
                    resresult4 := SELECTSTR(4, resresult);
                    resresult5 := SELECTSTR(5, resresult);
                    resresult6 := SELECTSTR(6, resresult);

                    IF resresult1 = 'SUCCESS' THEN BEGIN
                        IF NOT EInvoiceDetail.GET(rec."No.") THEN BEGIN
                            EInvoiceDetail.INIT;
                            EInvoiceDetail."Document No." := rec."No.";
                            EInvoiceDetail."E-Invoice IRN No." := resresult2;
                            EInvoiceDetail."URL for PDF" := resresult4;
                            //****************Code for the Download QR Image From URL**************//
                            QRFileName := rec."No." + '_' + 'QRIamge' + '.png';
                            if client.Get(resresult3, URLResponse) then begin
                                if URLResponse.IsSuccessStatusCode() then begin
                                    URLResponse.Content.ReadAs(IntS);
                                    TempBlob1.CreateOutStream(Outs);
                                    SLEEP(3000);
                                    EInvoiceDetail."E-Invoice QR Code".CreateOutStream(Outs);
                                    CopyStream(Outs, IntS);
                                    Sleep(3000);
                                    //*********Download QR Image to local System*********//
                                    // DownloadFromStream(IntS, '', '', '', QRFileName);
                                END else
                                    Error('QR Response Error- %1', URLResponse.ReasonPhrase);
                            END else
                                Error('QR Iamge Client Error %1', URLResponse.ReasonPhrase);

                            EInvoiceDetail."E-Invoice Acknowledg No." := resresult5;
                            Evaluate(resresultDT6, resresult6);
                            EInvoiceDetail."E-Invoice Acknowledg Date Time" := resresultDT6;
                            EInvoiceDetail.INSERT;
                            MESSAGE('E-Invoice has been generated.');
                        END;

                        IF EInvoiceDetail.GET(rec."No.") THEN BEGIN
                            IF EInvoiceDetail."URL for PDF" = '' THEN BEGIN
                                EInvoiceDetail."URL for PDF" := resresult4;
                                EInvoiceDetail.MODIFY;
                            END;
                            MESSAGE('URL Added.');
                        END;

                    END;
                END ELSE
                    ERROR(result);

            end
            else begin
                Einvcontent := EinvResponse.Content;
                Einvcontent.ReadAs(result);
                Error('E-Invoice Response: %1', result);
            end;
        end;

        //PCPL41-EINV

    end;
    //PCPL/NSW/EINV 050522

    procedure GetEinvoiceRequest(): Text
    var
    begin

    end;

    procedure GetTokenRequest(): Text;
    var
        JObject: JsonObject;
        result: Text;
        GLSetup: Record "General Ledger Setup";
    begin
        GLSetup.get;
        JObject.Add('baseURL', GLSetup."EINV Base URL");
        JObject.Add('username', GLSetup."EINV User Name");
        JObject.Add('password', GLSetup."EINV Password");
        JObject.Add('client_id', GLSetup."EINV Client ID");
        JObject.Add('client_secret', GLSetup."EINV Client Secret");
        JObject.Add('grant_type', GLSetup."EINV Grant Type");
        JObject.WriteTo(result);
        exit(result);
    end;

    local procedure GetTcsAmtLineWise(TaxRecordID: RecordId; var JObject: JsonObject): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        TaxTypeObjHelper: Codeunit "Tax Type Object Helper";
        ComponentAmt: Decimal;
        JArray: JsonArray;
        ComponentJObject: JsonObject;
    begin
        if not GuiAllowed then
            exit;

        TaxTransactionValue.SetFilter("Tax Record ID", '%1', TaxRecordID);
        TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::Component);
        TaxTransactionValue.SetRange("Visible on Interface", true);
        TaxTransactionValue.SetRange("Tax Type", 'TCS');
        //if TaxTransactionValue.FindSet() then
        if TaxTransactionValue.FindFirst() then
            //repeat
            begin
            Clear(ComponentJObject);
            //ComponentJObject.Add('Component', TaxTransactionValue.GetAttributeColumName());
            //ComponentJObject.Add('Percent', ScriptDatatypeMgmt.ConvertXmlToLocalFormat(format(TaxTransactionValue.Percent, 0, 9), "Symbol Data Type"::NUMBER));
            ComponentAmt := TaxTypeObjHelper.GetComponentAmountFrmTransValue(TaxTransactionValue);
            //ComponentJObject.Add('Amount', ScriptDatatypeMgmt.ConvertXmlToLocalFormat(format(ComponentAmt, 0, 9), "Symbol Data Type"::NUMBER));
            JArray.Add(ComponentJObject);
        end;
        //        TCSAMTLinewise := ComponentAmt;
        //until TaxTransactionValue.Next() = 0;
        exit(ComponentAmt)

    end;

    local procedure GetGSTBaseAmtLineWise(TaxRecordID: RecordId; var JObject: JsonObject): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        TaxTypeObjHelper: Codeunit "Tax Type Object Helper";
        ComponentAmt: Decimal;
        JArray: JsonArray;
        ComponentJObject: JsonObject;
        ScriptDatatypeMgmt: Codeunit "Script Data Type Mgmt.";
    begin
        if not GuiAllowed then
            exit;

        TaxTransactionValue.SetFilter("Tax Record ID", '%1', TaxRecordID);
        TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::Component);
        TaxTransactionValue.SetRange("Visible on Interface", true);
        TaxTransactionValue.SetRange("Tax Type", 'GST');
        TaxTransactionValue.SetRange("Value ID", 10);
        //if TaxTransactionValue.FindSet() then
        if TaxTransactionValue.FindFirst() then
            //repeat
            begin
            Clear(ComponentJObject);
            ComponentJObject.Add('Component', TaxTransactionValue.GetAttributeColumName());
            ComponentJObject.Add('Percent', ScriptDatatypeMgmt.ConvertXmlToLocalFormat(format(TaxTransactionValue.Percent, 0, 9), "Symbol Data Type"::NUMBER));
            ComponentAmt := TaxTypeObjHelper.GetComponentAmountFrmTransValue(TaxTransactionValue);
            //ComponentJObject.Add('Amount', ScriptDatatypeMgmt.ConvertXmlToLocalFormat(format(ComponentAmt, 0, 9), "Symbol Data Type"::NUMBER));
            JArray.Add(ComponentJObject);
        end;
        exit(ComponentAmt)

    end;
    //PCPL/NSW/EINV 050522



    local procedure CancelEInvoice();
    var
        //EInvGT: DotNet EInvTokenController;
        //EInvGEC: DotNet EInvController;
        token: Text;
        result: Text;
        resresult: Text;
        resresult1: Text;
        resresult2: Text;
        GeneralLedgerSetup: Record 98;
        Location: Record 14;
        EInvoiceDetail: Record "E-Invoice Detail";
        CancelPos: Text;
    begin
        //PCPL41-EINV
        IF EInvoiceDetail.GET(rec."No.") THEN BEGIN
            GeneralLedgerSetup.GET;
            // EInvGT := EInvGT.TokenController;
            // token := EInvGT.GetToken(GeneralLedgerSetup."EINV Base URL", GeneralLedgerSetup."EINV User Name", GeneralLedgerSetup."EINV Password",
            // GeneralLedgerSetup."EINV Client ID", GeneralLedgerSetup."EINV Client Secret", GeneralLedgerSetup."EINV Grant Type");

            IF Location.GET(rec."Location Code") then;
            // EInvGEC := EInvGEC.eInvoiceController;
            // result := EInvGEC.CancelEInvoice(GeneralLedgerSetup."EINV Base URL", token, Location."GST Registration No.", EInvoiceDetail."E-Invoice IRN No.", EInvoiceDetail."Cancel Remark", '1',
            // rec."No.", GeneralLedgerSetup."EINV Path");

            CLEAR(CancelPos);
            CancelPos := COPYSTR(result, 1, 2);

            IF CancelPos = 'Y;' THEN BEGIN
                resresult := CONVERTSTR(result, ';', ',');
                resresult1 := SELECTSTR(1, resresult);
                resresult2 := SELECTSTR(2, resresult);

                IF resresult1 = 'Y' THEN BEGIN
                    EInvoiceDetail."Cancel IRN No." := resresult2;
                    EInvoiceDetail."E-Invoice IRN No." := '';
                    CLEAR(EInvoiceDetail."E-Invoice QR Code");
                    CLEAR(EInvoiceDetail."URL for PDF");
                    EInvoiceDetail.MODIFY;
                    MESSAGE('E-Invoice has been cancelled');
                END;
            END ELSE
                ERROR(result);
        END;
        //PCPL41-EINV
    end;

    local procedure GetTcsAmtLineWiseEway(TaxRecordID: RecordId; var JObject: JsonObject): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        TaxTypeObjHelper: Codeunit "Tax Type Object Helper";
        ComponentAmtTCS: Decimal;
        JArray: JsonArray;
        ComponentJObject: JsonObject;
    begin
        if not GuiAllowed then
            exit;

        TaxTransactionValue.SetFilter("Tax Record ID", '%1', TaxRecordID);
        TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::Component);
        TaxTransactionValue.SetRange("Visible on Interface", true);
        TaxTransactionValue.SetRange("Tax Type", 'TCS');
        //if TaxTransactionValue.FindSet() then
        if TaxTransactionValue.FindFirst() then
            //repeat
            begin
            Clear(ComponentJObject);
            //ComponentJObject.Add('Component', TaxTransactionValue.GetAttributeColumName());
            //ComponentJObject.Add('Percent', ScriptDatatypeMgmt.ConvertXmlToLocalFormat(format(TaxTransactionValue.Percent, 0, 9), "Symbol Data Type"::NUMBER));
            ComponentAmtTCS := TaxTypeObjHelper.GetComponentAmountFrmTransValue(TaxTransactionValue);
            //ComponentJObject.Add('Amount', ScriptDatatypeMgmt.ConvertXmlToLocalFormat(format(ComponentAmt, 0, 9), "Symbol Data Type"::NUMBER));
            JArray.Add(ComponentJObject);
        end;
        //        TCSAMTLinewise := ComponentAmt;
        //until TaxTransactionValue.Next() = 0;
        exit(ComponentAmtTCS)

    end;

    local procedure GetGSTBaseAmtLineWiseEWAY(TaxRecordID: RecordId; var JObject: JsonObject): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        TaxTypeObjHelper: Codeunit "Tax Type Object Helper";
        ComponentAmtGSTVBase: Decimal;
        JArray: JsonArray;
        ComponentJObject: JsonObject;
    begin
        if not GuiAllowed then
            exit;

        TaxTransactionValue.SetFilter("Tax Record ID", '%1', TaxRecordID);
        TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::Component);
        TaxTransactionValue.SetRange("Visible on Interface", true);
        TaxTransactionValue.SetRange("Tax Type", 'GST');
        TaxTransactionValue.SetRange("Value ID", 10);
        //if TaxTransactionValue.FindSet() then
        if TaxTransactionValue.FindFirst() then
            //repeat
            begin
            Clear(ComponentJObject);
            //ComponentJObject.Add('Component', TaxTransactionValue.GetAttributeColumName());
            //ComponentJObject.Add('Percent', ScriptDatatypeMgmt.ConvertXmlToLocalFormat(format(TaxTransactionValue.Percent, 0, 9), "Symbol Data Type"::NUMBER));
            ComponentAmtGSTVBase := TaxTypeObjHelper.GetComponentAmountFrmTransValue(TaxTransactionValue);
            //ComponentJObject.Add('Amount', ScriptDatatypeMgmt.ConvertXmlToLocalFormat(format(ComponentAmt, 0, 9), "Symbol Data Type"::NUMBER));
            JArray.Add(ComponentJObject);
        end;
        exit(ComponentAmtGSTVBase)

    end;
    //PCPL/NSW/EINV 050522


    local procedure GetGSTBaseAmtLineWiseEWAYRetMsg(TaxRecordID: RecordId; var JObject: JsonObject): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        TaxTypeObjHelper: Codeunit "Tax Type Object Helper";
        ComponentAmtGSTVBaseretMsg: Decimal;
        JArray: JsonArray;
        ComponentJObject: JsonObject;
    begin
        if not GuiAllowed then
            exit;

        TaxTransactionValue.SetFilter("Tax Record ID", '%1', TaxRecordID);
        TaxTransactionValue.SetFilter("Value Type", '%1', TaxTransactionValue."Value Type"::Component);
        TaxTransactionValue.SetRange("Visible on Interface", true);
        TaxTransactionValue.SetRange("Tax Type", 'GST');
        TaxTransactionValue.SetRange("Value ID", 10);
        //if TaxTransactionValue.FindSet() then
        if TaxTransactionValue.FindFirst() then
            //repeat
            begin
            Clear(ComponentJObject);
            ComponentAmtGSTVBaseretMsg := TaxTypeObjHelper.GetComponentAmountFrmTransValue(TaxTransactionValue);
            JArray.Add(ComponentJObject);
        end;
        exit(ComponentAmtGSTVBaseretMsg)

    end;
    //PCPL/NSW/EINV 050522
    local procedure ConvertDt(AckDt2: Text): Text;
    var
        YYYY: Text;
        MM: Text;
        DD: Text;
        DateTime: Text;
        DT: Text;
    begin
        YYYY := COPYSTR(AckDt2, 1, 4);
        MM := COPYSTR(AckDt2, 6, 2);
        DD := COPYSTR(AckDt2, 9, 2);

        // TIME := COPYSTR(AckDt2,12,8);

        //DateTime := DD + '-' + MM + '-' + YYYY + ' ' + COPYSTR(AckDt2,11,8);
        DT := DD + '/' + MM + '/' + YYYY;
        EXIT(DT);
    end;

    local procedure GetDT(InputString: Text[30]) YourDT: DateTime;
    var
        Day: Integer;
        Month: Integer;
        Year: Integer;
        TheTime: Time;
    begin

        EVALUATE(Day, COPYSTR(InputString, 9, 2));  //2021-10-25192500
        EVALUATE(Month, COPYSTR(InputString, 6, 2));
        EVALUATE(Year, COPYSTR(InputString, 1, 4));
        EVALUATE(TheTime, COPYSTR(InputString, 11, 6));
        YourDT := CREATEDATETIME(DMY2DATE(Day, Month, Year), TheTime);

    end;


    procedure GetStatisticsPostedSalesInvAmount(
        SalesInvHeader: Record "Sales Invoice Header";
        var GSTAmount: Decimal; var AmountToCust: Decimal)
    var
        SalesInvLine: Record "Sales Invoice Line";
        TotalAmount: decimal;
    begin
        Clear(GSTAmount);

        SalesInvLine.SetRange("Document No.", SalesInvHeader."No.");
        if SalesInvLine.FindSet() then
            repeat
                GSTAmount += GetGSTAmount(SalesInvLine.RecordId());
                TotalAmount += SalesInvLine."Line Amount" - SalesInvLine."Line Discount Amount";
            until SalesInvLine.Next() = 0;
        AmountToCust := GSTAmount + TotalAmount;
    end;

    local procedure GetGSTAmount(RecID: RecordID): Decimal
    var
        TaxTransactionValue: Record "Tax Transaction Value";
        GSTSetup: Record "GST Setup";
    begin
        if not GSTSetup.Get() then
            exit;

        TaxTransactionValue.SetRange("Tax Record ID", RecID);
        TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
        if GSTSetup."Cess Tax Type" <> '' then
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type", GSTSetup."Cess Tax Type")
        else
            TaxTransactionValue.SetRange("Tax Type", GSTSetup."GST Tax Type");
        TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
        if not TaxTransactionValue.IsEmpty() then
            TaxTransactionValue.CalcSums(Amount);

        exit(TaxTransactionValue.Amount);
    end;

    var
        EINVGen: Boolean;
        SalesInvHeader: Record 112;
        EINVCan: Boolean;
        EWAYGEN: Boolean;

    trigger OnAfterGetRecord()
    var
        EInvoiceDetailNew: record 50601;
    begin
        //PCPL41-EINV
        EInvoiceDetailNew.RESET;
        EInvoiceDetailNew.SETRANGE("Document No.", rec."No.");
        IF NOT EInvoiceDetailNew.FINDFIRST THEN BEGIN
            EINVGen := TRUE;
            EINVCan := FALSE;
        END;

        EInvoiceDetailNew.RESET;
        EInvoiceDetailNew.SETRANGE("Document No.", rec."No.");
        EInvoiceDetailNew.SetFilter("E-Invoice IRN No.", '<>%1', '');
        IF EInvoiceDetailNew.FINDFIRST THEN BEGIN
            EINVGen := FALSE;
            EINVCan := TRUE;
        END;
    end;

    trigger OnOpenPage()
    var
        //EWayBillDetailNew: Record 50008;
        EInvoiceDetailNew: record 50601;
    begin

        //PCPL41-EINV
        EInvoiceDetailNew.RESET;
        EInvoiceDetailNew.SETRANGE("Document No.", rec."No.");
        IF NOT EInvoiceDetailNew.FINDFIRST THEN BEGIN
            EINVGen := TRUE;
            EINVCan := FALSE;
        END;

        EInvoiceDetailNew.RESET;
        EInvoiceDetailNew.SETRANGE("Document No.", rec."No.");
        EInvoiceDetailNew.SetFilter("E-Invoice IRN No.", '<>%1', '');
        IF EInvoiceDetailNew.FINDFIRST THEN BEGIN
            EINVGen := FALSE;
            EINVCan := TRUE;
        END;
        //PCPL41-EINV

        //PCPL0017-EWAY
        // EWayBillDetailNew.RESET;
        // EWayBillDetailNew.SETRANGE("Document No.", "No.");
        // EWayBillDetailNew.SETFILTER("Eway Bill No.", '<>%1', '');
        // IF EWayBillDetailNew.FINDFIRST THEN BEGIN
        //     EWAYGEN := FALSE;
        // END ELSE
        //     EWAYGEN := TRUE;
        //PCPL0017-EWAY

    end;




}

