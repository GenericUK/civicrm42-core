{*
 +--------------------------------------------------------------------+
 | CiviCRM version 4.2                                                |
 +--------------------------------------------------------------------+
 | Copyright CiviCRM LLC (c) 2004-2012                                |
 +--------------------------------------------------------------------+
 | This file is a part of CiviCRM.                                    |
 |                                                                    |
 | CiviCRM is free software; you can copy, modify, and distribute it  |
 | under the terms of the GNU Affero General Public License           |
 | Version 3, 19 November 2007 and the CiviCRM Licensing Exception.   |
 |                                                                    |
 | CiviCRM is distributed in the hope that it will be useful, but     |
 | WITHOUT ANY WARRANTY; without even the implied warranty of         |
 | MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.               |
 | See the GNU Affero General Public License for more details.        |
 |                                                                    |
 | You should have received a copy of the GNU Affero General Public   |
 | License and the CiviCRM Licensing Exception along                  |
 | with this program; if not, contact CiviCRM LLC                     |
 | at info[AT]civicrm[DOT]org. If you have questions about the        |
 | GNU Affero General Public License or the licensing of CiviCRM,     |
 | see the CiviCRM license FAQ at http://civicrm.org/licensing        |
 +--------------------------------------------------------------------+
*}
{* This file provides the HTML for the on-behalf-of form. Can also be used for related contact edit form. *}

{if $buildOnBehalfForm or $onBehalfRequired}
  <fieldset id="for_organization" class="for_organization-group">
  <legend>{$fieldSetTitle}</legend>
  {if ( $relatedOrganizationFound or $onBehalfRequired ) and !$organizationName}
    <div id='orgOptions' class="section crm-section">
       <div class="content">
        {$form.org_option.html}
       </div>
    </div>
  {/if}

<div id="select_org" class="crm-section">
  {foreach from=$onBehalfOfFields item=onBehaldField key=fieldName}
    {if $onBehalfOfFields.$fieldName.skipDisplay}
      {continue}
    {/if}
    {if $onBehalfOfFields.$fieldName.field_type eq "Formatting"}
      {$onBehalfOfFields.$fieldName.help_pre}
      {continue}
    {/if}
    <div class="crm-section {$onBehalfOfFields.$fieldName.name}-section">
      {if $onBehalfOfFields.$fieldName.help_pre}
        &nbsp;&nbsp;<span class='description'>{$onBehalfOfFields.$fieldName.help_pre}</span>
      {/if}

       {if ( $fieldName eq 'organization_name' ) and $organizationName}
        <div id='org_name' class="label">{$form.onbehalf.$fieldName.label}</div>
         <div class="content">
          {$form.onbehalf.$fieldName.html|crmReplace:class:big}
            <span>
              ( <a id='createNewOrg' href="#" onclick="createNew( ); return false;">{ts}Enter a new organization{/ts}</a> )
            </span>
            <div id="id-onbehalf-orgname-enter-help" class="description">
                {ts}Organization details have been prefilled for you. If this is not the organization you want to use, click "Enter a new organization" above.{/ts}
            </div>
            {if $onBehalfOfFields.$fieldName.help_post}
                 <span class='description'>{$onBehalfOfFields.$fieldName.help_post}</span>
            {/if}
         </div>
       {else}
        {if $onBehalfOfFields.$fieldName.options_per_line}
          <div class="label option-label">{$form.onbehalf.$fieldName.label}</div>
          <div class="content">
              {assign var="count" value="1"}
              {strip}
              <table class="form-layout-compressed">
              <tr>
                {* sort by fails for option per line. Added a variable to iterate through the element array*}
                {assign var="index" value="1"}
                {foreach name=outer key=key item=item from=$form.onbehalf.$fieldName}
                {if $index < 10}
                  {assign var="index" value=`$index+1`}
                {else}
                    <td class="labels font-light">{$form.onbehalf.$fieldName.$key.html}</td>
                  {if $count == $onBehalfOfFields.$fieldName.options_per_line}
                    </tr>
                    <tr>
                    {assign var="count" value="1"}
                  {else}
                       {assign var="count" value=`$count+1`}
                  {/if}
                {/if}
                {/foreach}
              </tr>
              </table>
              {/strip}
              {if $onBehalfOfFields.$fieldName.help_post}
                 <span class='description'>{$onBehalfOfFields.$fieldName.help_post}</span>
              {/if}
            </div>
          {else}
              <div class="label">{$form.onbehalf.$fieldName.label}</div>
              <div class="content">
              {if $fieldName eq 'organization_name' and !empty($form.onbehalfof_id)}
                {$form.onbehalfof_id.html}
              {/if}
              {$form.onbehalf.$fieldName.html}
              {if !empty($onBehalfOfFields.$fieldName.html_type)  && $onBehalfOfFields.$fieldName.html_type eq 'Autocomplete-Select'}
                {assign var=elementName value=onbehalf[$fieldName]}
                {include file="CRM/Custom/Form/AutoComplete.tpl" element_name=$elementName}
              {/if}
              {if $onBehalfOfFields.$fieldName.help_post}
                <br /><span class='description'>{$onBehalfOfFields.$fieldName.help_post}</span>
              {/if}
              </div>
          {/if}
       {/if}
      <div class="clear"></div>
    </div>
    {/foreach}
  </div>
  <div>{$form.mode.html}</div>
{/if}

{if empty($snippet)}
{literal}
<script type="text/javascript">

  showOnBehalf({/literal}"{$onBehalfRequired}"{literal});

cj( "#mode" ).hide( );
cj( "#mode" ).attr( 'checked', 'checked' );
  if ( cj( "#mode" ).attr( 'checked' ) && !{/literal}"{$reset}"{literal} ) {
    $text = ' {/literal}{ts escape="js"}Use existing organization{/ts}{literal} ';
    cj( "#createNewOrg" ).text( $text );
    cj( "#mode" ).removeAttr( 'checked' );
}

function showOnBehalf( onBehalfRequired )
{
    if ( cj( "#is_for_organization" ).attr( 'checked' ) || onBehalfRequired ) {
    var urlPath = {/literal}"{crmURL p=$urlPath h=0 q="snippet=4&onbehalf=1&id=$contributionPageID&qfKey=$qfKey"}";
    {if $mode eq 'test'}
      urlPath += '&action=preview';
    {/if}
    {if $reset}
      urlPath += '&reset={$reset}';
    {/if}{literal}
    cj("#onBehalfOfOrg").show();
    if (cj("fieldset", '#onBehalfOfOrg').length < 1) {
      cj('#onBehalfOfOrg').load(urlPath);
    }
     } else {
    cj("#onBehalfOfOrg").hide();
  }
}

function resetValues() {
  cj('input[type=text], select, textarea', "#select_org div").not('#onbehalfof_id').val('');
  cj('input[type=radio], input[type=checkbox]', "#select_org tr td").prop('checked', false);
}

function createNew( )
{
    if ( cj( "#mode" ).attr( 'checked' ) ) {
    var textMessage = ' {/literal}{ts escape="js"}Use existing organization{/ts}{literal} ';
        cj( "#onbehalf_organization_name" ).removeAttr( 'readonly' );
        cj( "#mode" ).removeAttr( 'checked' );

        resetValues();
    } else {
    var textMessage = ' {/literal}{ts escape="js"}Enter a new organization{/ts}{literal} ';
        cj( "#mode" ).attr( 'checked', 'checked' );
        setOrgName( );
    }
  cj("#createNewOrg").text(textMessage);
}

function setOrgName( )
{
    var orgName = "{/literal}{$organizationName}{literal}";
    var orgId   = "{/literal}{$orgId}{literal}";
    cj( "#onbehalf_organization_name" ).val( orgName );
    cj( "#onbehalf_organization_name" ).attr( 'readonly', true );
    setLocationDetails( orgId );
}


function setLocationDetails( contactID )
{
    resetValues();
    var locationUrl = {/literal}"{$locDataURL}"{literal} + contactID + "&ufId=" + {/literal}"{$profileId}"{literal};
    cj.ajax({
              url         : locationUrl,
              dataType    : "json",
              timeout     : 5000, //Time in milliseconds
              success     : function( data, status ) {
                for (var ele in data) {
                   if ( data[ele].type == 'Radio' ) {
                       if ( data[ele].value ) {
                           cj( "input[name='"+ ele +"']" ).filter( "[value=" + data[ele].value + "]" ).attr( 'checked', 'checked' );
                       }
		   } else if ( data[ele].type == 'CheckBox' ) {
		       if ( data[ele].value ) {
                           cj( "input[name='"+ ele +"']" ).attr( 'checked','checked' );
                       }
                   } else if ( data[ele].type == 'Multi-Select' ) {
                       for ( var selectedOption in data[ele].value ) {
                            cj( "#" + ele + " option[value='" + selectedOption + "']" ).attr( 'selected', 'selected' );
                       }
                   } else if ( data[ele].type == 'Autocomplete-Select' ) {
                       cj( "#" + ele ).val( data[ele].value );
                       cj( "#" + ele + '_id' ).val( data[ele].id );
        }
        else if (data[ele].type == 'AdvMulti-Select') {
          var customFld = ele.replace('onbehalf_', '');
          // remove empty value if any
          cj('#onbehalf\\['+ customFld +'\\]-f option[value=""]').remove();
          cj('#onbehalf\\['+ customFld +'\\]-t option[value=""]').remove();

          for (var selectedOption in data[ele].value) {
            // remove selected values from left and selected values to right
            cj('#onbehalf\\['+ customFld +'\\]-f option[value="' + selectedOption + '"]').remove()
              .appendTo('#onbehalf\\['+ customFld +'\\]-t');
          }
                   } else {
                       cj( "#" + ele ).val( data[ele].value );
                   }
                }
              },
              error       : function( XMLHttpRequest, textStatus, errorThrown ) {
                   console.error("HTTP error status: ", textStatus);
              }
    });
}

cj( "input:radio[name='org_option']" ).click( function( ) {
  var orgOption = cj(this).val();
  selectCreateOrg( orgOption, true );
});

cj('#onbehalfof_id').change(function() {
  setLocationDetails(cj(this).val());
}).change();

function selectCreateOrg( orgOption, reset )
{
    if ( orgOption == 0 ) {
      cj("#onbehalfof_id").show().change();
      cj("input#onbehalf_organization_name").hide();
    } else if ( orgOption == 1 ) {
      cj("input#onbehalf_organization_name").show();
      cj("#onbehalfof_id").hide();
    }

    if ( reset ) {
        resetValues();
    }
}

{/literal}{if ( $relatedOrganizationFound or $onBehalfRequired ) and $reset and $organizationName}
    setOrgName( );
{else}
       cj( "#orgOptions" ).show( );
       var orgOption = cj( "input:radio[name=org_option]:checked" ).val( );
       selectCreateOrg( orgOption, false );
{/if}{literal}
</script>
{/literal}
</fieldset>


{literal}
<script type="text/javascript">
{/literal}

{* If mid present in the url, take the required action (poping up related existing contact ..etc) *}
{if $membershipContactID}
    {literal}
    cj( function( ) {
        cj( '#organization_id' ).val("{/literal}{$membershipContactName}{literal}");
        cj( '#organization_name' ).val("{/literal}{$membershipContactName}{literal}");
        cj( '#onbehalfof_id' ).val("{/literal}{$membershipContactID}{literal}");
        setLocationDetails( "{/literal}{$membershipContactID}{literal}" );
    });
    {/literal}
{/if}

</script>
{/if}
