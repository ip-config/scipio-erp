<#--
This file is subject to the terms and conditions defined in the
files 'LICENSE' and 'NOTICE', which are part of this source
code package.
-->

    <#-- reference number -->
    <#if txType?default("") == "PRDS_PAY_CREDIT" || txType?default("") == "PRDS_PAY_CAPTURE" || 
         txType?default("") == "PRDS_PAY_RELEASE" || txType?default("") == "PRDS_PAY_REFUND">
        <#assign dummy = setRequestAttribute("validTx", "true")>
        <#assign validTx = true>
        <hr />
        <@field type="input" size="30" maxlength="60" name="referenceNum" label=uiLabelMap.AccountingReferenceNumber required=true/>
        <@field type="text" size="20" maxlength="20" name="orderPaymentPreferenceId" label=uiLabelMap.FormFieldTitle_orderPaymentPreferenceId required=true />      
    </#if>
    <#-- manual credit card information -->
    <#if txType?default("") == "PRDS_PAY_RELEASE">      
      <#assign dummy = setRequestAttribute("validTx", "true")>
      <@script>
        document.manualTxForm.action = "<@ofbizUrl>processReleaseTransaction</@ofbizUrl>";
      </@script>      
    </#if>
    <#if txType?default("") == "PRDS_PAY_REFUND">      
      <#assign dummy = setRequestAttribute("validTx", "true")>
      <@script>
        document.manualTxForm.action = "<@ofbizUrl>processRefundTransaction</@ofbizUrl>";
      </@script>    
    </#if>
    <#if txType?default("") == "PRDS_PAY_CREDIT" || txType?default("") == "PRDS_PAY_AUTH">     
        <#assign dummy = setRequestAttribute("validTx", "true")>
        <@script>
            document.manualTxForm.action = "<@ofbizUrl>processManualCcTx</@ofbizUrl>";
        </@script>     
        <hr/>      
        <@field type="input" size="30" maxlength="60" name="firstName" value=((person.firstName)!) label=uiLabelMap.PartyFirstName required=true />        
        <@field type="input" size="30" maxlength="60" name="lastName" value=((person.lastName)!) label=uiLabelMap.PartyLastName required=true />   
        <@field type="input" size="30" maxlength="60" name="infoString" value="" label=uiLabelMap.PartyEmailAddress required=true />       
        <hr/>
        <@render resource="component://accounting/widget/CommonScreens.xml#creditCardFields" />      
        <hr/>      
        <#-- first / last name -->
        
        <#assign disabled = false />
        <#if requestParameters.useShipAddr??><#assign disabled = true /></#if>
        <@field type="input" size="30" maxlength="30" name="firstName" value=((person.firstName)!) disabled=disabled label=uiLabelMap.PartyFirstName required=true/>
        <@field type="input" size="30" maxlength="30" name="lastName" value=((person.lastName)!) disabled=disabled label=uiLabelMap.PartyLastName required=true/>         
      
        <#-- credit card address -->     
        <@field type="input" size="30" maxlength="30" name="address1" value=((postalFields.address1)!) label=uiLabelMap.AccountingBillToAddress1 disabled=disabled required=true />
        <@field type="input" size="30" maxlength="30" name="address2" value=((postalFields.address2)!) label=uiLabelMap.AccountingBillToAddress2 disabled=disabled required=true />
        <@field type="input" size="30" maxlength="30" name="city" value=((postalFields.city)!) label=uiLabelMap.CommonCity disabled=disabled required=true />
        <@field type="select" name="stateProvinceGeoId" label=uiLabelMap.CommonStateProvince disabled=disabled required=true>
            <@render resource="component://common/widget/CommonScreens.xml#states" ctxVars={"currentStateProvinceGeoId":(postalFields.stateProvinceGeoId)!, statesPreselectFirst:true}/>
        </@field>
        <@field type="input" size="12" maxlength="10" name="postalCode" value=((postalFields.postalCode)!) label=uiLabelMap.CommonZipPostalCode disabled=disabled required=true/>
        <@field type="select" name="countryGeoId" disabled=disabled label=uiLabelMap.CommonCountry required=true>
            <@render resource="component://common/widget/CommonScreens.xml#countries" ctxVars={"currentCountryGeoId":(postalFields.countryGeoId)!, "countriesPreselectFirst":true} />
        </@field>        
    </#if>