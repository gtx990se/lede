var j=Object.defineProperty,A=Object.defineProperties;var B=Object.getOwnPropertyDescriptors;var p=Object.getOwnPropertySymbols;var _=Object.prototype.hasOwnProperty,k=Object.prototype.propertyIsEnumerable;var N=(e,t,s)=>t in e?j(e,t,{enumerable:!0,configurable:!0,writable:!0,value:s}):e[t]=s,o=(e,t)=>{for(var s in t||(t={}))_.call(t,s)&&N(e,s,t[s]);if(p)for(var s of p(t))k.call(t,s)&&N(e,s,t[s]);return e},d=(e,t)=>A(e,B(t));var c=(e,t)=>{var s={};for(var n in e)_.call(e,n)&&t.indexOf(n)<0&&(s[n]=e[n]);if(e!=null&&p)for(var n of p(e))t.indexOf(n)<0&&k.call(e,n)&&(s[n]=e[n]);return s};import{r,j as H}from"./vendor.38e754a4.js";const L="_spining_4i8sg_1",R="_spining_keyframes_4i8sg_1";var V={spining:L,spining_keyframes:R};const{useState:q}=H;function K({children:e}){return r.exports.createElement("span",{className:V.spining},e)}const P={right:10,bottom:10},Q=s=>{var n=s,{children:e}=n,t=c(n,["children"]);return r.exports.createElement("button",d(o({type:"button"},t),{className:"rtf--ab"}),e)},w=s=>{var n=s,{children:e}=n,t=c(n,["children"]);return r.exports.createElement("button",o({type:"button",className:"rtf--mb"},t),e)},z={bottom:24,right:24},S=D=>{var g=D,{event:e="hover",style:t=z,alwaysShowTitle:s=!1,children:n,icon:$,mainButtonStyles:h,onClick:b,text:f}=g,v=c(g,["event","style","alwaysShowTitle","children","icon","mainButtonStyles","onClick","text"]);const[i,m]=q(!1),u=s||!i,x=()=>m(!0),E=()=>m(!1),C=()=>e==="hover"&&x(),I=()=>e==="hover"&&E(),y=a=>b?b(a):(a.persist(),e==="click"?i?E():x():null),F=(a,l)=>{a.persist(),m(!1),setTimeout(()=>{l(a)},1)},M=()=>r.exports.Children.map(n,(a,l)=>r.exports.isValidElement(a)?r.exports.createElement("li",{className:`rtf--ab__c ${"top"in t?"top":""}`},r.exports.cloneElement(a,d(o({"data-testid":`action-button-${l}`,"aria-label":a.props.text||`Menu button ${l+1}`,"aria-hidden":u,tabIndex:i?0:-1},a.props),{onClick:O=>{a.props.onClick&&F(O,a.props.onClick)}})),a.props.text&&r.exports.createElement("span",{className:`${"right"in t?"right":""} ${s?"always-show":""}`,"aria-hidden":u},a.props.text)):null);return r.exports.createElement("ul",o({onMouseEnter:C,onMouseLeave:I,className:`rtf ${i?"open":"closed"}`,"data-testid":"fab",style:t},v),r.exports.createElement("li",{className:"rtf--mb__c"},r.exports.createElement(w,{onClick:y,style:h,"data-testid":"main-button",role:"button","aria-label":"Floating menu",tabIndex:0},$),f&&r.exports.createElement("span",{className:`${"right"in t?"right":""} ${s?"always-show":""}`,"aria-hidden":u},f),r.exports.createElement("ul",null,M())))};export{Q as A,S as F,K as I,P as p};
