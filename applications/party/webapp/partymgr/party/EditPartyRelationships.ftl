<#--
Licensed to the Apache Software Foundation (ASF) under one
or more contributor license agreements.  See the NOTICE file
distributed with this work for additional information
regarding copyright ownership.  The ASF licenses this file
to you under the Apache License, Version 2.0 (the
"License"); you may not use this file except in compliance
with the License.  You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing,
software distributed under the License is distributed on an
"AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
KIND, either express or implied.  See the License for the
specific language governing permissions and limitations
under the License.
-->

<br />
<div class="screenlet">
  <div class="screenlet-title-bar">
    <h3>${uiLabelMap.PartyRelationships}</h3>
  </div>
  <div class="screenlet-body">
    <#if partyRelationships?has_content>
      <table class="basic-table" cellspacing="0">
          <tr class="header-row">
            <td>${uiLabelMap.CommonDescription}/${uiLabelMap.CommonComments}</td>
            <td colspan="2">${uiLabelMap.CommonFromDate}/${uiLabelMap.CommonThruDate}</td>            
          </tr>
        <#list partyRelationships as partyRelationship>
          <#assign partyRelationshipType = partyRelationship.getRelatedOneCache("PartyRelationshipType")?if_exists>
          <#assign roleTypeTo = partyRelationship.getRelatedOneCache("ToRoleType")>
          <#assign roleTypeFrom = partyRelationship.getRelatedOneCache("FromRoleType")>
          <tr>
            <td>
              <div>
              ${uiLabelMap.PartyParty}&nbsp;<span class="label">${partyRelationship.partyIdTo}</span>
              <#if "_NA_" != partyRelationship.roleTypeIdTo>
                ${uiLabelMap.PartyRole} <b>${roleTypeTo.get("description",locale)}</b>
              </#if>
              ${uiLabelMap.CommonIsA}&nbsp;<span class="label">${(partyRelationshipType.get("partyRelationshipName",locale))?default("${uiLabelMap.CommonNA}")}</span>
              ${uiLabelMap.CommonOf} ${uiLabelMap.PartyParty}&nbsp;<span class="label">${partyRelationship.partyIdFrom}</span>
              <#if "_NA_" != partyRelationship.roleTypeIdFrom>
                ${uiLabelMap.PartyRole}&nbsp;<span class="label">${roleTypeFrom.get("description",locale)}</span>
              </#if>
              <#if partyRelationship.securityGroupId?exists>
                ${uiLabelMap.CommonAnd} ${uiLabelMap.PartyRelationSecurity}&nbsp;<span class="label">${partyRelationship.getRelatedOne("SecurityGroup").get("description",locale)}</span>
              </#if>
              </div>
            </td>
            <td colspan="2">
                ${partyRelationship.fromDate}
                <#if security.hasEntityPermission("PARTYMGR", "_REL_DELETE", session)>
                    <a href="<@ofbizUrl>deletePartyRelationship?partyIdTo=${partyRelationship.partyIdTo}&amp;roleTypeIdTo=${partyRelationship.roleTypeIdTo}&amp;roleTypeIdFrom=${partyRelationship.roleTypeIdFrom}&amp;partyIdFrom=${partyRelationship.partyIdFrom}&amp;fromDate=${partyRelationship.fromDate}&amp;partyId=${partyId?if_exists}</@ofbizUrl>" class="smallSubmit">${uiLabelMap.CommonRemove}</a>
                </#if>
            </td>
          <#if security.hasEntityPermission("PARTYMGR", "_REL_UPDATE", session)>
            <tr>
              <form method="post" name="updatePartyRel${partyRelationship_index}" action="<@ofbizUrl>updatePartyRelationship</@ofbizUrl>">
                <input type="hidden" name="partyId" value="${partyId}"/>
                <input type="hidden" name="partyIdFrom" value="${partyRelationship.partyIdFrom}"/>
                <input type="hidden" name="roleTypeIdFrom" value="${partyRelationship.roleTypeIdFrom}"/>
                <input type="hidden" name="partyIdTo" value="${partyRelationship.partyIdTo}"/>
                <input type="hidden" name="roleTypeIdTo" value="${partyRelationship.roleTypeIdTo}"/>
                <input type="hidden" name="fromDate" value="${partyRelationship.fromDate}"/>
                <td>
                  <input type="text" size="50" maxlength="30" name="comments" value="${partyRelationship.comments?if_exists}"/>
                </td>
                <td colspan="2">
                  <input type="text" size="24" name="thruDate" value="${partyRelationship.thruDate?if_exists}"/>
                  <a href="javascript:call_cal(document.updatePartyRel${partyRelationship_index}.thruDate, null);"><img src="<@ofbizContentUrl>/images/cal.gif</@ofbizContentUrl>" width="16" height="16" border="0" alt="Calendar"/></a>
                  <input type="submit" value="${uiLabelMap.CommonUpdate}"/>
                </td>
              </form>
            </tr>
          <#else>
            <tr>
              <td>
                ${partyRelationship.comments?if_exists}
              </td>
              <td colspan="2">
                ${partyRelationship.thruDate?if_exists}
              </td>
            </tr>
          </#if>
        </#list>
      </table>
    <#else/>
      ${uiLabelMap.PartyNoPartyRelationshipsFound}
    </#if>
  </div>
</div>
<#if security.hasEntityPermission("PARTYMGR", "_REL_UPDATE", session)>
  <div class="screenlet">
    <div class="screenlet-title-bar">
      <h3>${uiLabelMap.PartyNewRelationship}</h3>
    </div>
    <div class="screenlet-body">
      <form name="addPartyRelationshipTo" method="post" action="<@ofbizUrl>createPartyRelationship</@ofbizUrl>">
        <input type="hidden" name="partyId" value="${partyId}"/>
        <input type="hidden" name="partyIdFrom" value="${partyId}"/>
        <b>
          ${uiLabelMap.PartyPartyWithId}
          <input type="text" size="20" name="partyIdTo"/>
          <a href="javascript:call_fieldlookup2(document.addPartyRelationshipTo.partyIdTo,'LookupPartyName');"><img src='/images/fieldlookup.gif' width='15' height='14' border='0' alt='Click here For Field Lookup'/></a>
          ${uiLabelMap.PartyPartyInTheRoleOf}
          <select name="roleTypeIdTo">
            <#list roleTypes as roleType>
              <option <#if "_NA_" == roleType.roleTypeId>selected="selected"</#if> value="${roleType.roleTypeId}">${roleType.get("description",locale)}<#-- [${roleType.roleTypeId}]--></option>
            </#list>
          </select>
          ${uiLabelMap.CommonIsA}
          <select name="partyRelationshipTypeId">
            <#list relateTypes as relateType>
              <option value="${relateType.partyRelationshipTypeId}">${relateType.get("partyRelationshipName",locale)}<#-- [${relateType.partyRelationshipTypeId}]--></option>
            </#list>
          </select>
          ${uiLabelMap.PartyPartyOfTheRoleParty}
          <select name="roleTypeIdFrom">
            <#list roleTypesForCurrentParty as roleType>
              <option <#if "_NA_" == roleType.roleTypeId>selected="selected"</#if> value="${roleType.roleTypeId}">${roleType.get("description",locale)}<#-- [${roleType.roleTypeId}]--></option>
            </#list>
          </select>
          <#-- set security group specific to this party relationship -->
          <br/>${uiLabelMap.CommonAnd} ${uiLabelMap.PartyRelationSecurity} 
          <select name="securityGroupId">
            <option value="">&nbsp;</option>
            <#list securityGroups as securityGroup>
              <option value="${securityGroup.groupId}">${securityGroup.get("description",locale)}</option>
            </#list>
          </select><br/>
          ${uiLabelMap.CommonFrom} <input type="text" size="24" name="fromDate"/><a href="javascript:call_cal(document.addPartyRelationshipTo.fromDate, null);"><img src="<@ofbizContentUrl>/images/cal.gif</@ofbizContentUrl>" width="16" height="16" border="0" alt="Calendar"/></a>
          ${uiLabelMap.CommonThru} <input type="text" size="24" name="thruDate"/><a href="javascript:call_cal(document.addPartyRelationshipTo.thruDate, null);"><img src="<@ofbizContentUrl>/images/cal.gif</@ofbizContentUrl>" width="16" height="16" border="0" alt="Calendar"/></a>
        </b>
        ${uiLabelMap.CommonComments}:&nbsp;&nbsp;<input type="text" size="60" name="comments"/>
        <a href="javascript:document.addPartyRelationshipTo.submit()" class="smallSubmit">${uiLabelMap.CommonAdd}</a>
      </form>
      <hr>
      <form name="addPartyRelationshipFrom" method="post" action="<@ofbizUrl>createPartyRelationship</@ofbizUrl>">
        <input type="hidden" name="partyId" value="${partyId}"/>
        <input type="hidden" name="partyIdTo" value="${partyId}"/>
        <b>
          ${uiLabelMap.PartyPartyCurrentInTheRoleOf}
          <select name="roleTypeIdTo">
            <#list roleTypesForCurrentParty as roleType>
              <option <#if "_NA_" == roleType.roleTypeId>selected="selected"</#if> value="${roleType.roleTypeId}">${roleType.get("description",locale)}<#-- [${roleType.roleTypeId}]--></option>
            </#list>
          </select>
          ${uiLabelMap.CommonIsA}
          <select name="partyRelationshipTypeId">
            <#list relateTypes as relateType>
              <option value="${relateType.partyRelationshipTypeId}">${relateType.get("partyRelationshipName",locale)}<#-- [${relateType.partyRelationshipTypeId}]--></option>
            </#list>
          </select>
          ${uiLabelMap.PartyPartyWithId}
          <input type="text" size="20" name="partyIdFrom"/>
          <a href="javascript:call_fieldlookup2(document.addPartyRelationshipFrom.partyIdFrom,'LookupPartyName');"><img src='/images/fieldlookup.gif' width='15' height='14' border='0' alt='Click here For Field Lookup'/></a>
          ${uiLabelMap.PartyPartyInTheRoleOf}
          <select name="roleTypeIdFrom">
            <#list roleTypes as roleType>
              <option <#if "_NA_" == roleType.roleTypeId>selected="selected"</#if> value="${roleType.roleTypeId}">${roleType.get("description",locale)}<#-- [${roleType.roleTypeId}]--></option>
            </#list>
          </select>
          <br/>${uiLabelMap.CommonAnd} ${uiLabelMap.PartyRelationSecurity}
          <select name="securityGroupId">
            <option value="">&nbsp;</option>
            <#list securityGroups as securityGroup>
              <option value="${securityGroup.groupId}">${securityGroup.get("description",locale)}</option>
            </#list>
          </select><br/>
          ${uiLabelMap.CommonFrom} <input type="text" size="24" name="fromDate"/><a href="javascript:call_cal(document.addPartyRelationshipFrom.fromDate, null);"><img src="<@ofbizContentUrl>/images/cal.gif</@ofbizContentUrl>" width="16" height="16" border="0" alt="Calendar"/></a>
          ${uiLabelMap.CommonThru} <input type="text" size="24" name="thruDate"/><a href="javascript:call_cal(document.addPartyRelationshipFrom.thruDate, null);"><img src="<@ofbizContentUrl>/images/cal.gif</@ofbizContentUrl>" width="16" height="16" border="0" alt="Calendar"/></a>
        </b>
        ${uiLabelMap.CommonComments}:&nbsp;&nbsp;<input type="text" size="60" name="comments"/>
        <a href="javascript:document.addPartyRelationshipFrom.submit()" class="smallSubmit">${uiLabelMap.CommonAdd}</a>
      </form>
    </div>
  </div>
</#if>
<!-- end EditPartyRelationships.ftl -->