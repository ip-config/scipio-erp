<#--
This file is subject to the terms and conditions defined in the
files 'LICENSE' and 'NOTICE', which are part of this source
code package.
-->

<#if !giftCard??>
  <#assign sectionTitle = uiLabelMap.AccountingCreateNewGiftCard>
<#else>
  <#assign sectionTitle = uiLabelMap.AccountingEditGiftCard>
</#if>
<@section title=sectionTitle>
    <#macro saveCancelMenu>
      <@menu type="button">
        <@menuitem type="link" href=makeOfbizUrl("${donePage}?partyId=${partyId}") text=uiLabelMap.CommonCancelDone class="+${styles.action_nav!} ${styles.action_cancel!}" />
        <@menuitem type="link" href="javascript:document.editgiftcardform.submit()" text=uiLabelMap.CommonSave class="+${styles.action_run_sys!} ${styles.action_update!}" />
      </@menu>
    </#macro>
        
    <#--<@saveCancelMenu />-->
     
    <#if !giftCard??>
      <form method="post" action="<@ofbizUrl>createGiftCard?DONE_PAGE=${donePage}</@ofbizUrl>" name="editgiftcardform">
    <#else>
      <form method="post" action="<@ofbizUrl>updateGiftCard?DONE_PAGE=${donePage}</@ofbizUrl>" name="editgiftcardform">
        <input type="hidden" name="paymentMethodId" value="${paymentMethodId}" />
    </#if>
        <input type="hidden" name="partyId" value="${partyId}"/>
        
        <@field type="input" label=uiLabelMap.AccountingCardNumber size="20" maxlength="60" name="cardNumber" value=(giftCardData.cardNumber!) />
        <@field type="input" label=uiLabelMap.AccountingPinNumber size="10" maxlength="60" name="pinNumber" value=(giftCardData.pinNumber!) />
        <@field type="generic" label=uiLabelMap.CommonExpireDate>
            <#assign expMonth = "">
            <#assign expYear = "">
            <#if giftCardData?? && giftCardData.expireDate??>
              <#assign expDate = giftCard.expireDate>
              <#if (expDate?? && expDate.indexOf("/") > 0)>
                <#assign expMonth = expDate.substring(0,expDate.indexOf("/"))>
                <#assign expYear = expDate.substring(expDate.indexOf("/")+1)>
              </#if>
            </#if>
            <@field type="select" inline=true name="expMonth" onChange="javascript:makeExpDate();">
              <#if giftCardData?has_content && expMonth?has_content>
                <#assign ccExprMonth = expMonth>
              <#else>
                <#assign ccExprMonth = requestParameters.expMonth!>
              </#if>
              <#if ccExprMonth?has_content>
                <option value="${ccExprMonth!}">${ccExprMonth!}</option>
              </#if>
              <@render resource="component://common/widget/CommonScreens.xml#ccmonths" />
            </@field>
            <@field type="select" inline=true name="expYear" onChange="javascript:makeExpDate();">
              <#if giftCard?has_content && expYear?has_content>
                <#assign ccExprYear = expYear>
              <#else>
                <#assign ccExprYear = requestParameters.expYear!>
              </#if>
              <#if ccExprYear?has_content>
                <option value="${ccExprYear!}">${ccExprYear!}</option>
              </#if>
              <@render resource="component://common/widget/CommonScreens.xml#ccyears" />
            </@field>
        </@field>
        <@field type="input" label=uiLabelMap.CommonDescription size="30" maxlength="60" name="description" value=(paymentMethodData.description!) />

      </form>
      
      <@saveCancelMenu />
</@section>
