"use strict";(self.webpackChunkreact_test=self.webpackChunkreact_test||[]).push([[414],{725:(e,a,t)=>{t.r(a),t.d(a,{default:()=>o});t(5043),t(3774);var n=t(929),i=t(9073),s=t(788),r=(t(5613),t(4721),t(6724)),c=t(6261),l=t(4176),m=t(2840),p=t(579);const o=()=>(0,p.jsxs)("div",{className:"API",children:[(0,p.jsx)("title",{children:"API | OSGL"}),(0,p.jsx)(i.A,{}),(0,p.jsx)("div",{className:"sidebar-content",children:(0,p.jsx)(s.A,{links:l.A})}),(0,p.jsxs)("div",{className:"api-content",children:[(0,p.jsx)("h1",{className:"api-header",children:"Bitmap"}),(0,p.jsx)("div",{className:"api-header-line"}),(0,p.jsx)(m.A,{metadata:{core:!0,partialThreadSafe:!0}}),(0,p.jsx)("p",{className:"api-paragraph",children:"Bitmaps are specialized versions of textures with a variable amount of Color channels."}),(0,p.jsx)("h1",{className:"api-header",children:"Properties"}),(0,p.jsx)("div",{className:"api-header-line"}),(0,p.jsx)(r.A,{name:"width",fullName:"Bitmap.width",type:"number",desc:"The width of the bitmap."}),(0,p.jsx)(r.A,{name:"height",fullName:"Bitmap.height",type:"number",desc:"The height of the bitmap."}),(0,p.jsx)(r.A,{name:"buffer",fullName:"Bitmap.buffer",type:"buffer",desc:"The pixels that the bitmap is storing."}),(0,p.jsx)(r.A,{name:"channels",fullName:"Bitmap.channels",type:"number",desc:"The amount of channels the bitmap is storing."}),(0,p.jsx)("h1",{className:"api-header",children:"Functions"}),(0,p.jsx)("div",{className:"api-header-line"}),(0,p.jsx)(c.A,{name:"fromChecked",fullName:"Bitmap.fromChecked",params:{rawTexture:"RawTexture"},returnType:"Result<Bitmap, TextureError>",desc:"Creates a new Bitmap given a raw one.",code:"local OSGL = require(path.to.osgl)\nlocal Bitmap = OSGL.Bitmap\n\nlocal myBitmap = myBitmap.fromChecked(script.myBitmapModule)",metadata:{Checked:!0}}),(0,p.jsx)(c.A,{name:"fromUnchecked",fullName:"Bitmap.fromUnchecked",params:{rawTexture:"baseUnloadedTexture"},returnType:"Bitmap",desc:"Creates a new Bitmap given an unloaded one.",code:"local OSGL = require(path.to.osgl)\nlocal Bitmap = OSGL.Bitmap\n\nlocal bitmapData = require(script.myBitmapModulecript)\n\nlocal myBitmap = myBitmap.fromUnchecked(bitmapData)",metadata:{Unchecked:!0}}),(0,p.jsx)(c.A,{name:"Read",fullName:"Bitmap:Read",isMethod:!0,params:{x:"number",y:"number",channel:"number?"},returnType:"number",desc:"Reads a value from a specific channel of a pixel, defaulting to the first channel if one is not provided.",code:"local OSGL = require(path.to.osgl)\nlocal Bitmap = OSGL.Bitmap\n\nlocal bitmapData = require(script.myBitmapModulecript)\n\nlocal myBitmap = myBitmap.fromUnchecked(bitmapData)\n\n-- Read the 2nd channel of the pixel at (5, 5)\nprint(myBitmap:Read(5, 5, 2))",metadata:{Unchecked:!0}}),(0,p.jsx)(c.A,{name:"Write",fullName:"Bitmap:Write",isMethod:!0,params:{x:"number",y:"number",channel:"number",value:"number"},returnType:"nil",desc:"Writes a value to a specific channel of a pixel.",code:"local OSGL = require(path.to.osgl)\nlocal Bitmap = OSGL.Bitmap\n\nlocal bitmapData = require(script.myBitmapModulecript)\n\nlocal myBitmap = myBitmap.fromUnchecked(bitmapData)\n\n-- Write 255 to the second channel of the pixel at (5, 5)\nmyBitmap:Write(5, 5, 2, 255)",metadata:{Unchecked:!0}}),(0,p.jsx)("div",{style:{height:"55px"}})]}),(0,p.jsx)(n.A,{}),(0,p.jsx)("div",{className:"grid-background-dark"})]})},4721:(e,a,t)=>{t.d(a,{A:()=>l});var n=t(5043),i=t(2207),s=t(579);const r=e=>{let{name:a,definition:t}=e;const n=e=>e.split(/([&|])/).map(((e,a)=>{if("&"===e||"|"===e)return e;const t=e.match(/^\s*/)[0],n=e.match(/\s*$/)[0];return`${t}${(0,i.FD)(e.trim())}${n}`})).join("");let r="";if("string"===typeof t){const e=t.replace(/\?$/,""),i=t.endsWith("?");r=`type ${a} = ${n(e)}${i?"?":""};`}else if("object"===typeof t){r=`type ${a} = {\n${Object.entries(t).map((e=>{let[a,t]=e,i="",s="";return"string"===typeof t?i=n(t.replace(/\?$/,""))+(t.endsWith("?")?"?":""):"object"===typeof t&&t.type&&(i=n(t.type.replace(/\?$/,""))+(t.type.endsWith("?")?"?":""),s=t.comment?` -- ${t.comment}`:""),`    ${a}: ${i};${s}`})).join("\n")}\n}`}else r="/* Invalid Input */";return(0,s.jsx)("pre",{className:"output",dangerouslySetInnerHTML:{__html:(c=r,c.replace(/\b(type)\b/g,'<span class="keyword">$1</span>').replace(/(--.*)$/gm,'<span class="comment">$1</span>'))}});var c};var c=t(4221);const l=e=>{let{name:a,type:t,code:i}=e;const l=a.replace(/\s+/g,"-").toLowerCase();return(0,n.useEffect)((()=>{const e=()=>{if(window.location.hash===`#${l}`){const e=document.getElementById(l);e&&e.scrollIntoView({behavior:"smooth",block:"center"})}};return e(),window.addEventListener("hashchange",e),()=>{window.removeEventListener("hashchange",e)}}),[l]),(0,s.jsxs)("div",{children:[(0,s.jsx)("code",{id:l,className:"api-name-header",children:a}),(0,s.jsx)("br",{}),(0,s.jsx)(r,{name:a,definition:t}),i&&(0,s.jsx)("div",{className:"code-block",children:(0,s.jsx)(c.A,{code:i,language:"lua"})})]})}}}]);
//# sourceMappingURL=414.cfc469d6.chunk.js.map