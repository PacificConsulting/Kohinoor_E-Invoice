pageextension 50603 "Posted_sales_CrMemo_ext EINV" extends "Posted Sales Credit Memo"
{
    // version NAVW19.00.00.48466,NAVIN9.00.00.48466

    layout
    {
        addafter(General)
        {
            group("E-Invoice Details")
            {
                part("E-Invoice Detail"; "E-Invoice Detail")
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
        modify("Import E-Invoice Response")
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
                Enabled = EINVGen;
                Image = ExportFile;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;

                trigger OnAction();
                var
                    // EwayBillGT: DotNet EInvTokenController;
                    //EwayBillGEI: DotNet EInvController;
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
                    IF Rec."Nature of Supply" = rec."Nature of Supply"::B2C then
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
            action("Cancel E-Invoice New")
            {
                Enabled = EINVCan;
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;

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
        //GSTManagement: Codeunit 16401;
        LRNo: Text;
        lrDate: Text;
        mont: Text;
        PDate: Text;
        Dt: Text;
        JsonString: Text;
        // GSTEInvoice: Codeunit 50008;
        //recAuthData: Record 50037;
        recGSTRegNos: Record "GST Registration Nos.";
        genledSetup: Record 98;
        signedData: Text;
        decryptedIRNResponse: Text;
        cnlrem: Text;

    local procedure GenerateEInvoice();
    var
        // EInvGT: DotNet EInvTokenController;
        //EInvGEI: DotNet EInvController;
        token: Text;
        result: Text;
        resresult: Text;
        resresult1: Text;
        resresult2: Text;
        resresult3: Text;
        resresult4: Text;
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
        //TempBlob: Record "99008535";
        TempBlob1: Codeunit "Temp Blob";
        ServerFileNameTxt: Text;
        ClientFileNameTxt: Text;
        EInvoiceDetail: Record 50601;
        EINVPos: Text;
        GSTRate: Decimal;
        SalesCrMemoLine: Record 115;
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
        UOM: Text;
        RoundOff: Decimal;
        Natureofsupply: Text;
        ExpCustomer: Record 18;
        SCL: Record 115;
        IntS: InStream;
        outS: OutStream;
        SalesCrMemoLineNewEinv: Record "Sales Cr.Memo Line";
        TaxRecordID: RecordId;
        GSTBaseAmtLineWise: Decimal;
        ComponentJobject: JsonObject;
        TCSAMTLinewise: Decimal;
        DetailedGSTLedgerEntryNew: Record "Detailed GST Ledger Entry";
        GSTPer: Integer;
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
        GLSetup: Record "General Ledger Setup";
    begin
        //PCPL41-EINV
        CLEAR(Natureofsupply);
        ExpCustomer.GET(rec."Sell-to Customer No.");
        IF rec."GST Customer Type" = "GST Customer Type"::Export THEN BEGIN
            Natureofsupply := 'EXPWOP';
            transactiondetails := Natureofsupply + '!' + 'N' + '!' + '' + '!' + 'N';
        END ELSE
            IF ExpCustomer."GST Customer Type" = ExpCustomer."GST Customer Type"::"SEZ Unit" THEN BEGIN
                Natureofsupply := 'SEZWOP';
                transactiondetails := Natureofsupply + '!' + 'N' + '!' + '' + '!' + 'N';
            END ELSE
                transactiondetails := FORMAT(rec."Nature of Supply") + '!' + 'N' + '!' + '' + '!' + 'N';

        Document_Date := FORMAT(rec."Posting Date", 0, '<Day,2>/<Month,2>/<year4>');
        documentdetails := 'CRN' + '!' + rec."No." + '!' + Document_Date;

        CompanyInformation.GET;
        Location.GET(rec."Location Code");
        State.GET(Location."State Code");
        LocPhoneNo := DELCHR(Location."Phone No.", '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)');
        sellerdetails := Location."GST Registration No." + '!' + CompanyInformation.Name + '!' + Location.Name + '!' + Location.Address + '!' + Location."Address 2" + '!' +
        rec."Location Code" + '!' + Location."Post Code" + '!' + State."State Code (GST Reg. No.)" + '!' + LocPhoneNo + '!' + Location."E-Mail";

        dispatchdetails := Location.Name + '!' + Location.Address + '!' + Location."Address 2" + '!' + rec."Location Code" + '!' + Location."Post Code" + '!' + State.Description;

        Customer.GET(rec."Sell-to Customer No.");
        BuyState.GET(Customer."State Code");
        CustPhoneNo := DELCHR(Customer."Phone No.", '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)');
        buyerdetails := Customer."GST Registration No." + '!' + Customer.Name + '!' + Customer."Name 2" + '!' + Customer.Address + '!' + Customer."Address 2" + '!' +
        Customer.City + '!' + Customer."Post Code" + '!' + BuyState."State Code (GST Reg. No.)" + '!' + BuyState.Description + '!' + CustPhoneNo + '!' +
        Customer."E-Mail";

        //PCPL 38
        IF ExpCustomer."GST Customer Type" = ExpCustomer."GST Customer Type"::Export THEN BEGIN//PCPL50 begin and else if end
            IF ExpCustomer."State Code" = '' THEN
                buyerdetails := 'URP' + '!' + Customer.Name + '!' + Customer."Name 2" + '!' + Customer.Address + '!' + Customer."Address 2" + '!' +
                Customer.City + '!' + '999999' + '!' + '96' + '!' + '96' + '!' + CustPhoneNo + '!' +
                Customer."E-Mail";
            //PCPL 38
        END
        ELSE
            IF ExpCustomer."GST Customer Type" <> ExpCustomer."GST Customer Type"::Export THEN BEGIN //PCPL0017-21-09-2021
                SCL.RESET;
                SCL.SETRANGE("Document No.", rec."No.");
                IF SCL.FINDFIRST THEN
                    REPEAT
                        IF (SCL.Type <> SCL.Type::" ") AND (SCL.Quantity <> 0) THEN BEGIN
                            IF SCL."GST Place of Supply" = SCL."GST Place of Supply"::"Ship-to Address" THEN
                                IF rec."Ship-to Code" <> '' THEN
                                    ShiptoAddress.RESET;
                            ShiptoAddress.SETRANGE(ShiptoAddress.Code, Rec."Ship-to Code");
                            ShiptoAddress.SETRANGE(ShiptoAddress."Customer No.", Rec."Sell-to Customer No.");
                            IF ShiptoAddress.FINDFIRST THEN BEGIN
                                ShipState.GET(ShiptoAddress.State);
                                CustPhoneNo := DELCHR(ShiptoAddress."Phone No.", '=', '!|@|#|$|%|^|&|*|/|''|\|-| |(|)');
                                buyerdetails := ShiptoAddress."GST Registration No." + '!' + ShiptoAddress.Name + '!' + ShiptoAddress."Name 2" + '!' + ShiptoAddress.Address + '!' + ShiptoAddress."Address 2" + '!' +
                                ShiptoAddress.City + '!' + ShiptoAddress."Post Code" + '!' + ShipState."State Code (GST Reg. No.)" + '!' + ShipState.Description + '!' + CustPhoneNo + '!' +
                                ShiptoAddress."E-Mail";
                            END;
                        END;
                    UNTIL SCL.NEXT = 0;
            END;  //PCPL50 begin and else if end

        //PCPL0017-21-09-2021
        IF (ExpCustomer."GST Customer Type" = ExpCustomer."GST Customer Type"::Export) THEN BEGIN //PCPL0017-21-09-2021
            shipdetails := 'URP' + '!' + Customer.Name + '!' + Customer."Name 2" + '!' + Customer.Address + '!' + Customer."Address 2" + '!' +
            Customer.City + '!' + '999999' + '!' + '96';
        END ELSE //PCPL50 begin and else if end
            IF (ExpCustomer."GST Customer Type" <> ExpCustomer."GST Customer Type"::Export) THEN BEGIN //PCPL0017-21-09-2021
                IF rec."Ship-to Code" <> '' THEN BEGIN
                    ShiptoAddress.RESET;
                    ShiptoAddress.SETRANGE(ShiptoAddress.Code, rec."Ship-to Code");
                    ShiptoAddress.SETRANGE(ShiptoAddress."Customer No.", rec."Sell-to Customer No.");
                    IF ShiptoAddress.FINDFIRST THEN BEGIN
                        ShipState.GET(ShiptoAddress.State);
                        shipdetails := ShiptoAddress."GST Registration No." + '!' + ShiptoAddress.Name + '!' + ShiptoAddress."Name 2" + '!' + ShiptoAddress.Address + '!' +
                        ShiptoAddress."Address 2" + '!' + ShiptoAddress.City + '!' + ShiptoAddress."Post Code" + '!' + ShipState.Description;
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
        Clear(GSTBaseAmtLineWise);
        Clear(TaxRecordID);
        Clear(ComponentJobject);
        Clear(TCSAMTLinewise);
        Clear(GSTPer);

        SalesCrMemoLine.RESET;
        SalesCrMemoLine.SETCURRENTKEY("Document No.");
        SalesCrMemoLine.SETRANGE("Document No.", rec."No.");
        SalesCrMemoLine.SETFILTER(Type, '<>%1', SalesCrMemoLine.Type::" ");
        SalesCrMemoLine.SETFILTER(Quantity, '<>%1', 0);
        //SalesCrMemoLine.SETFILTER(SalesCrMemoLine."Unit of Measure Code",'<>%1','');
        IF SalesCrMemoLine.FINDSET THEN
            REPEAT
                CLEAR(CGSTAmt);
                CLEAR(SGSTAmt);
                CLEAR(IGSTAmt);
                CLEAR(CESSGSTAmt);
                CLEAR(cgstrate);
                CLEAR(sgstrate);
                CLEAR(igstrate);
                CLEAR(cessrate);

                Clear(GSTBaseAmtLineWise);
                Clear(TaxRecordID);
                Clear(ComponentJobject);
                Clear(TCSAMTLinewise);
                Clear(GSTPer);

                DetailedGSTLedgerEntry.RESET;
                DetailedGSTLedgerEntry.SETCURRENTKEY("Transaction Type", "Document Type", "Document No.", "Document Line No.");
                DetailedGSTLedgerEntry.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
                DetailedGSTLedgerEntry.SETRANGE("Document No.", SalesCrMemoLine."Document No.");
                DetailedGSTLedgerEntry.SETRANGE("Document Line No.", SalesCrMemoLine."Line No.");
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


                //<<PCPL/NSW/EINV 052522
                DetailedGSTLedgerEntryNew.RESET;
                DetailedGSTLedgerEntryNew.SETCURRENTKEY("Transaction Type", "Document Type", "Document No.", "Document Line No.");
                DetailedGSTLedgerEntryNew.SETRANGE("Transaction Type", DetailedGSTLedgerEntry."Transaction Type"::Sales);
                DetailedGSTLedgerEntryNew.SETRANGE("Document No.", SalesCrMemoLine."Document No.");
                DetailedGSTLedgerEntryNew.SETRANGE("Document Line No.", SalesCrMemoLine."Line No.");
                IF DetailedGSTLedgerEntryNew.FINDSET THEN begin
                    GSTPer := DetailedGSTLedgerEntry."GST %";
                end;
                //>>PCPL/NSW/EINV 052522



                CLEAR(GSTRate);
                IF (CGSTAmt <> 0) AND (SGSTAmt <> 0) THEN
                    GSTRate := cgstrate + sgstrate;
                IF IGSTAmt <> 0 THEN
                    GSTRate := igstrate;
                IF CESSGSTAmt <> 0 THEN
                    GSTRate := cessrate;


                //<<PCPL/NSW/EINV 052522
                if SalesCrMemoLineNewEinv.Get(SalesCrMemoLine."Document No.", SalesCrMemoLine."Line No.") then
                    TaxRecordID := SalesCrMemoLineNewEinv.RecordId();
                TCSAMTLinewise := GetTcsAmtLineWise(TaxRecordID, ComponentJobject);
                GSTBaseAmtLineWise := GetGSTBaseAmtLineWise(TaxRecordID, ComponentJobject);
                //>>PCPL/NSW/EINV 052522

                /* /* <<PCPL/NSW/030522 
                IF SalesCrMemoLine."GST Base Amount" = 0 THEN
                    totaltaxableamt += SalesCrMemoLine.Amount
                ELSE
                    totaltaxableamt += SalesCrMemoLine."GST Base Amount";
                */ //<<PCPL/NSW/030522

                //<<PCPL/NSW/030522     
                IF GSTBaseAmtLineWise = 0 THEN
                    totaltaxableamt += SalesCrMemoLine.Amount
                ELSE
                    totaltaxableamt += GSTBaseAmtLineWise;
                //>>PCPL/NSW/030522 

                TotalCGSTAmt += CGSTAmt;
                TotalSGSTAmt += SGSTAmt;
                TotalIGSTAmt += IGSTAmt;
                TotalCessGSTAmt += CESSGSTAmt;

                totalcessnonadvolvalue += 0;
                TotalItemValue := SalesCrMemoLine."Line Amount" + CGSTAmt + SGSTAmt + IGSTAmt + CESSGSTAmt + TCSAMTLinewise;//SalesCrMemoLine."TDS/TCS Amount"; //PCPL/NSW/030522 
                totalinvoicevalue += SalesCrMemoLine."Line Amount" + CGSTAmt + SGSTAmt + IGSTAmt + CESSGSTAmt + TCSAMTLinewise;//SalesCrMemoLine."TDS/TCS Amount"; //PCPL/NSW/030522 
                totalcessvalueofstate += 0;
                IF SalesCrMemoLine."No." = '400003' then
                    totaldiscount += SalesCrMemoLine.Amount
                else
                    totaldiscount += SalesCrMemoLine."Line Discount Amount";
                totalothercharge += 0;//SalesCrMemoLine."Charges To Customer"; //PCPL/NSW/030522 

                IF SalesCrMemoLine."GST Group Type" = SalesCrMemoLine."GST Group Type"::Service THEN
                    IsService := 'Y'
                ELSE
                    IF SalesCrMemoLine."GST Group Type" = SalesCrMemoLine."GST Group Type"::Goods THEN
                        IsService := 'N';

                /*
                IF SalesCrMemoLine."Unit of Measure Code" = 'BL' THEN
                  UOM := 'OTH'
                ELSE IF SalesCrMemoLine."Unit of Measure Code" = 'KG' THEN
                  UOM := 'KGS'
                ELSE IF SalesCrMemoLine."Unit of Measure Code" = 'MT' THEN
                  UOM := 'MTS'
                ELSE
                  UOM := SalesCrMemoLine."Unit of Measure Code";
                */

                IF (SalesCrMemoLine.Type = SalesCrMemoLine.Type::"G/L Account") AND (SalesCrMemoLine."Unit of Measure Code" = '') THEN
                    UOM := 'NOS'
                ELSE
                    UOM := SalesCrMemoLine."Unit of Measure Code";

                CLEAR(RoundOff);
                IF SalesCrMemoLine."No." = GLSetup."Round of G/L Account" THEN
                    RoundOff := SalesCrMemoLine."Line Amount";

                IF (itemlist = '') AND (SalesCrMemoLine."No." <> GLSetup."Round of G/L Account") THEN
                    itemlist := FORMAT(SalesCrMemoLine."Line No.") + '!' + SalesCrMemoLine.Description + '!' + IsService + '!' + SalesCrMemoLine."HSN/SAC Code" + '!' + '' + '!' +
                    FORMAT(SalesCrMemoLine.Quantity) + '!' + '' + '!' + UOM + '!' + FORMAT(ROUND(SalesCrMemoLine."Unit Price", 0.01, '>')) + '!' +
                    FORMAT(SalesCrMemoLine."Line Amount") + '!' + '0' + '!' + FORMAT(SalesCrMemoLine."Line Discount Amount") + '!' + FORMAT(TCSAMTLinewise/*SalesCrMemoLine."TDS/TCS Amount"*/) +
                    '!' + FORMAT(GSTBaseAmtLineWise/*SalesCrMemoLine."Tax Base Amount"*/) + '!' +/*FORMAT(ROUND(SalesCrMemoLine."GST %",1,'='))*/FORMAT(GSTRate) + '!' + FORMAT(IGSTAmt) + '!' + FORMAT(CGSTAmt) + '!' +
                    FORMAT(SGSTAmt) + '!' + FORMAT(cessrate) + '!' + FORMAT(CESSGSTAmt) + '!' + '0' + '!' + '0' + '!' + '0' + '!' + '0' + '!' + FORMAT(TotalItemValue) +
                    '!' + '' + '!' + '' + '!' + '' + '!' + '' + '!' + '' + '!' + '' + '' + '!' + ''
                ELSE
                    IF SalesCrMemoLine."No." <> GLSetup."Round of G/L Account" THEN
                        itemlist := itemlist + ';' + FORMAT(SalesCrMemoLine."Line No.") + '!' + SalesCrMemoLine.Description + '!' + IsService + '!' + SalesCrMemoLine."HSN/SAC Code" +
                        '!' + '' + '!' + FORMAT(SalesCrMemoLine.Quantity) + '!' + '' + '!' + UOM + '!' +
                        /*FORMAT(ROUND(SalesCrMemoLine."Unit Price",0.01,'>'))*/FORMAT(GSTRate) + '!' + FORMAT(SalesCrMemoLine."Line Amount") + '!' + '0' + '!' +
                        FORMAT(SalesCrMemoLine."Line Discount Amount") + '!' + FORMAT(TCSAMTLinewise/*SalesCrMemoLine."TDS/TCS Amount"*/) + '!' + FORMAT(GSTBaseAmtLineWise/*SalesCrMemoLine."Tax Base Amount"*/) + '!' +
                        FORMAT(ROUND(/*SalesCrMemoLine."GST %"*/GSTPer, 1, '=')) + '!' + FORMAT(IGSTAmt) + '!' + FORMAT(CGSTAmt) + '!' + FORMAT(SGSTAmt) + '!' + FORMAT(cessrate) + '!' +
                        FORMAT(CESSGSTAmt) + '!' + '0' + '!' + '0' + '!' + '0' + '!' + '0' + '!' + FORMAT(TotalItemValue) + '!' + '' + '!' + '' + '!' + '' + '!' + '' + '!' + '' + '!' + '' +
                        '' + '!' + ''
UNTIL SalesCrMemoLine.NEXT = 0;

        valuedetails := FORMAT(totaltaxableamt) + '!' + FORMAT(TotalCGSTAmt) + '!' + FORMAT(TotalCGSTAmt) + '!' + FORMAT(TotalIGSTAmt) + '!' + FORMAT(TotalCessGSTAmt) + '!' +
        FORMAT(totalcessnonadvolvalue) + '!' + FORMAT(totalinvoicevalue) + '!' + FORMAT(totalcessvalueofstate) + '!' + FORMAT(RoundOff) + '!' + '0' + '!' + FORMAT(totaldiscount) + '!' +
        FORMAT(totalothercharge);

        GeneralLedgerSetup.GET;
        //api code
        // JsonTokenResult := GetTokenRequest();
        //Message(JsonTokenResult);
        /*
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
        AccessToken := '67118f6bfaa1efedba09c90f9b2bc578e70f8468';
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
        //DownloadFromStream(ReqInStm, '', '', '', FileName);
        clear(ReqtempBlob);//231122
                           //Message('File Download Request');

        //  CLEAR(EINVPos);
        //EINVPos := COPYSTR(result, 1, 8);
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

                    IF resresult1 = 'SUCCESS' THEN BEGIN
                        IF NOT EInvoiceDetail.GET(rec."No.") THEN BEGIN
                            EInvoiceDetail.INIT;
                            EInvoiceDetail."Document No." := rec."No.";
                            EInvoiceDetail."E-Invoice IRN No." := resresult2;
                            EInvoiceDetail."URL for PDF" := resresult4;
                            //****************Code for the Download QR Image From Http URL**************//
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
                                    Error('QR Response Error- %1', URLResponse.IsSuccessStatusCode);
                            END else
                                Error('QR Iamge Client Error %1', URLResponse.ReasonPhrase);
                            EInvoiceDetail."E-Invoice Acknowledg Date Time" := CurrentDateTime;
                            EInvoiceDetail.INSERT;
                            MESSAGE('E-Invoice has been generated.');
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

        end;
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

        // //PCPL0017-EWAY
        // EWayBillDetailNew.RESET;
        // EWayBillDetailNew.SETRANGE("Document No.", "No.");
        // EWayBillDetailNew.SETFILTER("Eway Bill No.", '<>%1', '');
        // IF EWayBillDetailNew.FINDFIRST THEN BEGIN
        //     EWAYGEN := FALSE;
        // END ELSE
        //     EWAYGEN := TRUE;
        // //PCPL0017-EWAY

    end;


    //<<PCPL/NSW/EINV 050522
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
    //>>PCPL/NSW/EINV 050522

    local procedure CancelEInvoice();
    var
        // EInvGT: DotNet EInvTokenController;
        //EInvGEC: DotNet EInvController;
        token: Text;
        result: Text;
        resresult: Text;
        resresult1: Text;
        resresult2: Text;
        GeneralLedgerSetup: Record 98;
        Location: Record 14;
        EInvoiceDetail: Record 50601;
        CancelPos: Text;
    begin
        //PCPL41-EINV
        IF EInvoiceDetail.GET(rec."No.") THEN BEGIN
            GeneralLedgerSetup.GET;
            // EInvGT := EInvGT.TokenController;
            // token := EInvGT.GetToken(GeneralLedgerSetup."EINV Base URL", GeneralLedgerSetup."EINV User Name", GeneralLedgerSetup."EINV Password",
            // GeneralLedgerSetup."EINV Client ID", GeneralLedgerSetup."EINV Client Secret", GeneralLedgerSetup."EINV Grant Type");

            Location.GET(rec."Location Code");
            // EInvGEC := EInvGEC.eInvoiceController;
            // result := EInvGEC.CancelEInvoice(GeneralLedgerSetup."EINV Base URL", token, Location."GST Registration No.", EInvoiceDetail."E-Invoice IRN No.", EInvoiceDetail."Cancel Remark", '1',
            // "No.", GeneralLedgerSetup."EINV Path");

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

    var
        EINVGen: Boolean;
        EINVCan: Boolean;
    //EWAYGEN: Boolean;




}

