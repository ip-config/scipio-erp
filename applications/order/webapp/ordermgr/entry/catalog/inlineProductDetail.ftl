<#--
This file is subject to the terms and conditions defined in the
files 'LICENSE' and 'NOTICE', which are part of this source
code package.
-->

${virtualJavaScript!}
<#assign addedJavaScript = requestAttributes.addedJavaScript?default("N")/>
<#if ("N" == addedJavaScript)>
  <#assign dummy = setRequestAttribute("addedJavaScript", "Y")>
  <@script>

     function popupDetailInline(inlineCounter) {
        var imageField = 'detailImage' + inlineCounter;
        var defaultDetailImage = document.getElementById(imageField);
        if (defaultDetailImage == null || defaultDetailImage == "null" || defaultDetailImage == "") {
            defaultDetailImage = "_NONE_";
        }
        var fieldName = 'detailImageUrl' + inlineCounter;
        if (window[fieldName] == null || window[fieldName] == "null") {
            window[fieldName] = defaultDetailImage;
        }

        if (window[fieldName] == "_NONE_") {
            hack = document.createElement('span');
            hack.innerHTML="${escapeVal(uiLabelMap.CommonNoDetailImageAvailableToDisplay, 'js')}";
            showErrorAlert("${escapeVal(uiLabelMap.CommonErrorMessage2, 'js')}","${escapeVal(uiLabelMap.CommonNoDetailImageAvailableToDisplay, 'js')}");
            return;
        }
        window[fieldName] = window[fieldName].replace(/\&\#47;/g, "/");
        popUp("<@ofbizUrl>detailImage?detail=" + window[fieldName] + "</@ofbizUrl>", 'detailImage', '400', '550');
    }

    function setAddProductIdInline(inlineCounter, name) {
        var add_product_id = 'add_product_id' + inlineCounter;
        var product_id_display = 'product_id_display' + inlineCounter;
        document.configform[add_product_id].value = name;
        if (name == '' || name == 'NULL' || isVirtualInline(inlineCounter, name) == true) {
            //document.configform.quantity.disabled = true;
            var elem = document.getElementById(product_id_display);
            var txt = document.createTextNode('');
            if(elem.hasChildNodes()) {
                elem.replaceChild(txt, elem.firstChild);
            } else {
                elem.appendChild(txt);
            }

            checkOption(inlineCounter);
        } else {
            //document.configform.quantity.disabled = false;
            var elem = document.getElementById(product_id_display);
            var txt = document.createTextNode(name);
            if(elem.hasChildNodes()) {
                elem.replaceChild(txt, elem.firstChild);
            } else {
                elem.appendChild(txt);
            }
        }
    }

    function checkOption(inlineCounter) {
        var option = document.getElementById(inlineCounter.substring(0, inlineCounter.length - 2));
        if (option.checked) {
            option.checked=false;
        }
    }

    function setVariantPriceInline(inlineCounter, sku) {
        var variant_price_display = 'variant_price_display' + inlineCounter;
        if (sku == '' || sku == 'NULL' || isVirtualInline(inlineCounter, sku) == true) {
            var elem = document.getElementById(variant_price_display);
            var txt = document.createTextNode('');
            if(elem.hasChildNodes()) {
                elem.replaceChild(txt, elem.firstChild);
            } else {
                elem.appendChild(txt);
            }
        }
        else {
            var elem = document.getElementById(variant_price_display);
            var functionName = 'getVariantPrice' + inlineCounter;
            var price =  window[functionName](sku);
            var txt = document.createTextNode('+' + price);
            if(elem.hasChildNodes()) {
                elem.replaceChild(txt, elem.firstChild);
            } else {
                elem.appendChild(txt);
            }
        }
    }
    function isVirtualInline(inlineCounter, product) {
        var isVirtual = false;
        var fieldName = 'VIR' + inlineCounter;
        <#if virtualJavaScript??>
        for (i = 0; i < window[fieldName].length; i++) {
            if (window[fieldName][i] == product) {
                isVirtual = true;
            }
        }
        </#if>
        return isVirtual;
    }

    function toggleAmtInline(inlineCounter, toggle) {
        var fieldName = 'add_amount' + inlineCounter;
        if (toggle == 'Y') {
            changeObjectVisibility(fieldName, "visible");
        }

        if (toggle == 'N') {
            changeObjectVisibility(fieldName, "hidden");
        }
    }

    function findIndexInline(varname, name ) {
        for (i = 0; i < window[varname].length; i++) {
            if ( window[varname][i] == name) {
                return i;
            }
        }
        return -1;
    }

    function checkOptionToggle(inlineCounter, disable) {
        var index = inlineCounter.indexOf('_');
        var optionElementName = inlineCounter.substring(0,index);
        var option = document.getElementById(optionElementName);
        if ("true" == disable) {
            option.disabled = true;
            if (option.checked == true) {
                option.checked == false;
            }
        } else {
            //check all virtual product for the option
        }
    }

    function checkOptionVariants(optionName) {
        var option = document.getElementById(optionName);
        if (option.checked == false) {
            return false;
        }

        var fieldName = "add_product_id" + optionName + "_";
        var index = 15 + optionName.toString().length;
        var cform = document.forms["configform"];
        var len = cform.elements.length;
        for (var i = 0; i < len; i++) {
            var element = cform.elements[i];
            if (element.name.substring(0, index) == fieldName) {
                 if (element.value == '' || element.value == 'NULL') {
                    option.checked = false;
                    showErrorAlert("${escapeVal(uiLabelMap.CommonErrorMessage2, 'js')}","${escapeVal(uiLabelMap.CommonPleaseSelectAllFeaturesFirst, 'js')}");
                    return false;
                }
            }
        }
    }

    function getListInline(inlineCounter, name, index, src) {
        currentFeatureIndex = findIndexInline('OPT'+inlineCounter, name);

        if (currentFeatureIndex == 0) {
            // set the images for the first selection
            if ([index] != null) {
                if (document.images['mainImage'+ inlineCounter] != null) {
                    document.images['mainImage'+ inlineCounter].src = window['IMG'+ inlineCounter][index];
                    window['detailImageUrl'+ inlineCounter] = window['DET'+ inlineCounter][index];
                }
            }

            // set the drop down index for swatch selection
            document.forms["configform"].elements[name].selectedIndex = (index*1)+1;
        }

        if (currentFeatureIndex < (window['OPT'+ inlineCounter].length-1)) {
            // eval the next list if there are more
            var selectedValue = document.forms["configform"].elements[name].options[(index*1)+1].value;
            if (index == -1) {
                var featureOrderFirst = window['OPT'+ inlineCounter][(currentFeatureIndex)].toString();
                var length = featureOrderFirst.length;
                featureOrderFirst = featureOrderFirst.substring(2, length);
                var Variable1 = eval("list" + featureOrderFirst + "()");
            } else {
                var Variable1 = eval("list" + window['OPT'+ inlineCounter][(currentFeatureIndex+1)] + selectedValue + "()");
            }

            // set the product ID to NULL to trigger the alerts
            setAddProductIdInline(inlineCounter, 'NULL');

            // set the variant price to NULL
            setVariantPriceInline(inlineCounter, 'NULL');

            //checkOptionToggle(inlineCounter, 'false');
        } else {
            // this is the final selection -- locate the selected index of the last selection
            var indexSelected = document.forms["configform"].elements[name].selectedIndex;

            // using the selected index locate the sku
            var sku = document.forms["configform"].elements[name].options[indexSelected].value;

            // set the product ID
            setAddProductIdInline(inlineCounter, sku);

            // set the variant price
            setVariantPriceInline(inlineCounter, sku);

            // check for amount box
            var functionName = 'checkAmtReq' + inlineCounter;
            toggleAmtInline(inlineCounter, window[functionName](sku));

            //checkOptionToggle(inlineCounter, 'true');
        }
    }


 </@script>
</#if>

<#if (product.virtualVariantMethodEnum!) == "VV_FEATURETREE" && featureLists?has_content>
  <@script>
        function checkRadioButtoninline${inlineCounter}(inlineCounter, productId) {
        var add_product_id = 'add_product_id' + inlineCounter;
            <#list featureLists as featureList>
                <#list featureList as feature>
                    <#if feature_index == 0>
                        var myList = document.getElementById("FT" +inlineCounter + "${feature.productFeatureTypeId}");
                         if (myList.options[0].selected == true) {
                             document.configform[add_product_id].value = 'NULL';
                             checkOption(inlineCounter);
                             return;
                         }
                        <#break>
                    </#if>
                </#list>
            </#list>
            document.configform[add_product_id].value = productId;
        }
  </@script>
</#if>


<#assign price = priceMap!/>
<div id="inlineproductdetail${inlineCounter}">
<@table type="fields" class="+${styles.table_spacing_tiny_hint!}" width="100%">
  <@tr>
    <@td align="left" valign="top" width="0">
      <#assign productLargeImageUrl = productContentWrapper.get("LARGE_IMAGE_URL", "url")!>
      <#if firstLargeImage?has_content>
        <#assign productLargeImageUrl = firstLargeImage>
      </#if>
      <#if productLargeImageUrl?has_content>
        <input type="hidden" name="detailImage${inlineCounter}" value="${firstDetailImage?default(mainDetailImageUrl?default("_NONE_"))}"/>
        <a href="javascript:popupDetailInline('${inlineCounter}');" class="${styles.link_type_image!} ${styles.action_run_sys!} ${styles.action_view!}"><img src="<@ofbizContentUrl ctxPrefix=true>${productLargeImageUrl}</@ofbizContentUrl>" name="mainImage${inlineCounter}" vspace="5" hspace="5" class="cssImgLarge" align="left" alt="" /></a>
      </#if>
    </@td>
    <@td align="right" valign="top" width="100%">
    <#--    <@heading>${productContentWrapper.get("PRODUCT_NAME")!}</@heading>  -->
        <#assign inStock = true>
        <#if (product.isVirtual!?upper_case) == "Y">
        <#if (product.virtualVariantMethodEnum!) == "VV_FEATURETREE" && featureLists?has_content>
            <#list featureLists as featureList>
                <#list featureList as feature>
                    <#if feature_index == 0>
                        <div>${feature.description}: <select id="FT${inlineCounter}${feature.productFeatureTypeId}" name="FT${inlineCounter}${feature.productFeatureTypeId}" onchange="javascript:checkRadioButtoninline${inlineCounter}('${inlineCounter}', '${product.productId}');">
                        <option value="select" selected="selected"> select option </option>
                    <#else>
                        <option value="${feature.productFeatureId}">${feature.description} <#if feature.price??>(+ <@ofbizCurrency amount=feature.price?string isoCode=feature.currencyUomId/>)</#if></option>
                    </#if>
                </#list>
                </select>
                </div>
            </#list>
              <input type="hidden" name="product_id${inlineCounter}" value="${product.productId}"/>
              <input type="hidden" name="add_product_id${inlineCounter}" value="NULL"/>
          </#if>
          <#if !product.virtualVariantMethodEnum?? || product.virtualVariantMethodEnum == "VV_VARIANTTREE">
           <#if variantTree?? && (variantTree.size() > 0)>
            <#list featureSet as currentType>
              <div>
                <select name="FT${inlineCounter}${currentType}" onchange="javascript:getListInline('${inlineCounter}', this.name, (this.selectedIndex-1), 1);">
                  <option>${featureTypes.get(currentType)}</option>
                </select>
              </div>
            </#list>
            <input type="hidden" name="product_id${inlineCounter}" value="${product.productId}"/>
            <input type="hidden" name="add_product_id${inlineCounter}" value="NULL"/>
            <div>
              <b><span id="product_id_display${inlineCounter}"> </span></b>
              <b><div id="variant_price_display${inlineCounter}"> </div></b>
            </div>
          <#else>
            <input type="hidden" name="product_id${inlineCounter}" value="${product.productId}"/>
            <input type="hidden" name="add_product_id${inlineCounter}" value="NULL"/>
            <div><b>${uiLabelMap.ProductItemOutOfStock}.</b></div>
            <#assign inStock = false>
          </#if>
         </#if>
        <#else>
          <input type="hidden" name="product_id${inlineCounter}" value="${product.productId}"/>
          <input type="hidden" name="add_product_id${inlineCounter}" value="${product.productId}"/>
          <#assign isStoreInventoryNotAvailable = !(Static["org.ofbiz.product.store.ProductStoreWorker"].isStoreInventoryAvailable(request, product, 1.0?double))>
          <#assign isStoreInventoryRequired = Static["org.ofbiz.product.store.ProductStoreWorker"].isStoreInventoryRequired(request, product)>
          <#if isStoreInventoryNotAvailable>
            <#if isStoreInventoryRequired>
              <div><b>${uiLabelMap.ProductItemOutOfStock}.</b></div>
              <#assign inStock = false>
            <#else>
              <div><b>${product.inventoryMessage!}</b></div>
            </#if>
          </#if>
        </#if>
      </@td></@tr>
      <@tr><@td COLSPAN="2" align="right">
        <#-- check to see if introductionDate hasnt passed yet -->
        <#if product.introductionDate?? && nowTimestamp.before(product.introductionDate)>
        <p>&nbsp;</p>
          <div class="${styles.text_color_alert!}">${uiLabelMap.ProductProductNotYetMadeAvailable}.</div>
        <#-- check to see if salesDiscontinuationDate has passed -->
        <#elseif product.salesDiscontinuationDate?? && nowTimestamp.after(product.salesDiscontinuationDate)>
          <div class="${styles.text_color_alert!}">${uiLabelMap.ProductProductNoLongerAvailable}.</div>
        <#-- check to see if the product requires inventory check and has inventory -->
        <#elseif (product.virtualVariantMethodEnum!) != "VV_FEATURETREE">
          <#if inStock>
            <#if product.requireAmount?default("N") == "Y">
              <#assign hiddenStyle = "visible">
            <#else>
              <#assign hiddenStyle = "hidden">
            </#if>
            <div id="add_amount${inlineCounter}" class="${hiddenStyle}">
              <span style="white-space: nowrap;"><b>${uiLabelMap.CommonAmount}:</b></span>&nbsp;
              <input type="text" size="5" name="add_amount${inlineCounter}" value=""/>
            </div>
           </#if>
        </#if>
      </@td></@tr>

      <@tr><@td COLSPAN="2" align="right">
      <#if variantTree?? && 0 < variantTree.size()>
        <@script>eval("list"+ "${inlineCounter}" + "${featureOrderFirst}" + "()");</@script>
      </#if>

      <#-- Swatches (virtual products only) . For now commented out, before fixing a bug
      <#if variantSample?? && 0 < variantSample.size()>
        <#assign imageKeys = variantSample.keySet()>
        <#assign imageMap = variantSample>
        <p>&nbsp;</p>
        <@table type="fields">
          <@tr>
            <#assign maxIndex = 7>
            <#assign indexer = 0>
            <#list imageKeys as key>
              <#assign swatchProduct = imageMap.get(key)>
              <#if swatchProduct?has_content && indexer < maxIndex>
                <#assign imageUrl = Static["org.ofbiz.product.product.ProductContentWrapper"].getProductContentAsText(swatchProduct, "SMALL_IMAGE_URL", request, "url")!>
                <#if !imageUrl?string?has_content>
                  <#assign imageUrl = productContentWrapper.get("SMALL_IMAGE_URL", "url")!>
                </#if>
                <#if !imageUrl?string?has_content>
                  <#assign imageUrl = "/images/defaultImage.jpg">
                </#if>
                <@td align="center" valign="bottom">
                  <a href="javascript:getListInline('${inlineCounter}', 'FT${inlineCounter}${featureOrderFirst}','${indexer}',1);" class="${styles.link_type_image!} ${styles.action_run_local!} ${styles.action_select!}"><img src="<@ofbizContentUrl ctxPrefix=true>${imageUrl}</@ofbizContentUrl>" border="0" width="60" height="60" alt="" /></a>
                  <br />
                  <a href="javascript:getListInline('${inlineCounter}', 'FT${inlineCounter}${featureOrderFirst}','${indexer}',1);" class="${styles.link_run_local!} ${styles.action_select!}">${key}</a>
                </@td>
              </#if>
              <#assign indexer = indexer + 1>
            </#list>
            <#if (indexer > maxIndex)>
              <div><b>${uiLabelMap.ProductMoreOptions}</b></div>
            </#if>
          </@tr>
        </@table>
      </#if>      -->
    </@td>
  </@tr>
</@table>
</div>
