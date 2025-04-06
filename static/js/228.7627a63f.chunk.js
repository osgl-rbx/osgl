"use strict";(self.webpackChunkosgl_docs=self.webpackChunkosgl_docs||[]).push([[228],{4721:(e,o,a)=>{a.d(o,{A:()=>t});var l=a(5043),r=a(2207),s=a(579);const n=e=>{let{name:o,definition:a}=e;const l=e=>e.split(/([&|])/).map(((e,o)=>{if("&"===e||"|"===e)return e;const a=e.match(/^\s*/)[0],l=e.match(/\s*$/)[0];return`${a}${(0,r.FD)(e.trim())}${l}`})).join("");let n="";if("string"===typeof a){const e=a.replace(/\?$/,""),r=a.endsWith("?");n=`type ${o} = ${l(e)}${r?"?":""};`}else if("object"===typeof a){n=`type ${o} = {\n${Object.entries(a).map((e=>{let[o,a]=e,r="",s="";return"string"===typeof a?r=l(a.replace(/\?$/,""))+(a.endsWith("?")?"?":""):"object"===typeof a&&a.type&&(r=l(a.type.replace(/\?$/,""))+(a.type.endsWith("?")?"?":""),s=a.comment?` -- ${a.comment}`:""),`    ${o}: ${r};${s}`})).join("\n")}\n}`}else n="/* Invalid Input */";return(0,s.jsx)("pre",{className:"output",dangerouslySetInnerHTML:{__html:(c=n,c.replace(/\b(type)\b/g,'<span class="keyword">$1</span>').replace(/(--.*)$/gm,'<span class="comment">$1</span>'))}});var c};var c=a(4221);const t=e=>{let{name:o,type:a,code:r}=e;const t=o.replace(/\s+/g,"-").toLowerCase();return(0,l.useEffect)((()=>{const e=()=>{if(window.location.hash===`#${t}`){const e=document.getElementById(t);e&&e.scrollIntoView({behavior:"smooth",block:"center"})}};return e(),window.addEventListener("hashchange",e),()=>{window.removeEventListener("hashchange",e)}}),[t]),(0,s.jsxs)("div",{children:[(0,s.jsx)("code",{id:t,className:"api-name-header",children:o}),(0,s.jsx)("br",{}),(0,s.jsx)(n,{name:o,definition:a}),r&&(0,s.jsx)("div",{className:"code-block",children:(0,s.jsx)(c.A,{code:r,language:"lua"})})]})}},5291:(e,o,a)=>{a.r(o),a.d(o,{default:()=>h});a(5043),a(3774);var l=a(929),r=a(9073),s=a(788),n=(a(5613),a(4721)),c=a(6724),t=a(6261),d=a(4176),m=a(2840),p=a(579);const h=()=>(0,p.jsxs)("div",{className:"API",children:[(0,p.jsx)("title",{children:"API | OSGL"}),(0,p.jsx)(r.A,{}),(0,p.jsx)("div",{className:"sidebar-content",children:(0,p.jsx)(s.A,{links:d.A})}),(0,p.jsxs)("div",{className:"api-content",children:[(0,p.jsx)("h1",{className:"api-header",children:"Color"}),(0,p.jsx)("div",{className:"api-header-line"}),(0,p.jsx)(m.A,{metadata:{core:!0,threadSafe:!0}}),(0,p.jsx)("p",{className:"api-paragraph",children:"The Color class handles the manipulation of color values."}),(0,p.jsx)("h1",{className:"api-header",children:"Types"}),(0,p.jsx)("div",{className:"api-header-line"}),(0,p.jsx)(n.A,{name:"Color",type:"number",code:"local OSGL = require(path.to.osgl)\nlocal color = OSGL.color\n\n-- All other parameters default to 0,\n-- except for alpha, which defaults to 255.\nlocal myAwesomeRedColor = color.new(255)"}),(0,p.jsx)("h1",{className:"api-header",children:"Properties"}),(0,p.jsx)("div",{className:"api-header-line"}),(0,p.jsx)(c.A,{name:"Red",fullName:"Color.RED",type:"Color",desc:"A red color."}),(0,p.jsx)(c.A,{name:"Green",fullName:"Color.GREEN",type:"Color",desc:"A green color."}),(0,p.jsx)(c.A,{name:"Blue",fullName:"Color.BLUE",type:"Color",desc:"A blue color."}),(0,p.jsx)(c.A,{name:"White",fullName:"Color.WHITE",type:"Color",desc:"A white color."}),(0,p.jsx)(c.A,{name:"Black",fullName:"Color.BLACK",type:"Color",desc:"A black color."}),(0,p.jsx)(c.A,{name:"Yellow",fullName:"Color.YELLOW",type:"Color",desc:"A yellow color."}),(0,p.jsx)(c.A,{name:"Magenta",fullName:"Color.MAGENTA",type:"Color",desc:"A magenta color."}),(0,p.jsx)(c.A,{name:"Cyan",fullName:"Color.CYAN",type:"Color",desc:"A cyan color."}),(0,p.jsx)(c.A,{name:"Transparent",fullName:"Color.TRANSPARENT",type:"Color",desc:"A transparent color."}),(0,p.jsx)("h1",{className:"api-header",children:"Functions"}),(0,p.jsx)("div",{className:"api-header-line"}),(0,p.jsx)(t.A,{name:"new",fullName:"Color.new",params:{r:"number?",g:"number?",b:"number?",a:{type:"number?",comment:"Alpha transparency."}},returnType:"Color",desc:"Creates a new RGBA color value.",code:"local OSGL = require(path.to.osgl)\nlocal color = OSGL.color\n\n-- All other parameters are defaulted\n-- to 0, except for alpha, which is\n-- defaulted to 255.\nlocal myAwesomeRedColor = color.new(255)",metadata:{ThreadSafe:!0}}),(0,p.jsx)(t.A,{name:"newRGB",fullName:"Color.newRGB",params:{r:"number?",g:"number?",b:"number?"},returnType:"Color",desc:"Creates a new RGBA color value from RGB.",code:"local OSGL = require(path.to.osgl)\nlocal color = OSGL.color\n\n-- All other parameters are defaulted\n-- to 0, except for alpha, which is\n-- defaulted to 255.\nlocal myAwesomeRedColor = color.new(255)",metadata:{ThreadSafe:!0}}),(0,p.jsx)(t.A,{name:"fromColor3",fullName:"Color.fromColor3",params:{color3:"Color3"},returnType:"Color",desc:"Creates a new RGBA color value from a Color3.",code:"local OSGL = require(path.to.osgl)\nlocal color = OSGL.color\n\nlocal myAwesomeRedColor = color.fromColor3(Color3.new(1, 0, 0))",metadata:{ThreadSafe:!0}}),(0,p.jsx)(t.A,{name:"setR",fullName:"Color.setR",params:{c:"Color",r:"number"},returnType:"Color",desc:"Sets the R channel of a Color.",code:"local almostRed = color.setR(color.BLACK, 100)",metadata:{ThreadSafe:!0}}),(0,p.jsx)(t.A,{name:"newG",fullName:"Color.setG",params:{c:"Color",g:"number"},returnType:"Color",desc:"Sets the G channel of a Color.",code:"local almostGreen = color.setG(color.BLACK, 100)",metadata:{ThreadSafe:!0}}),(0,p.jsx)(t.A,{name:"newB",fullName:"Color.setB",params:{c:"Color",b:"number"},returnType:"Color",desc:"Sets the B channel of a Color.",code:"local almostBlue = color.setB(color.BLACK, 100)",metadata:{ThreadSafe:!0}}),(0,p.jsx)(t.A,{name:"newA",fullName:"Color.setA",params:{c:"Color",a:"number"},returnType:"Color",desc:"Sets the A channel of a Color.",code:"local almostTransparent = color.setB(color.BLACK, 100)",metadata:{ThreadSafe:!0}}),(0,p.jsx)(t.A,{name:"read",fullName:"Color.read",params:{c:"Color"},returnType:"(number, number, number, number)",desc:"Reads the channels of a Color.",code:"local R, G, B, A = color.read(color.RED)",metadata:{ThreadSafe:!0}}),(0,p.jsx)(t.A,{name:"r",fullName:"Color.r",params:{c:"Color"},returnType:"Color",desc:"Reads R channel of a Color.",code:"local R = color.read(color.RED)",metadata:{ThreadSafe:!0}}),(0,p.jsx)(t.A,{name:"g",fullName:"Color.g",params:{c:"Color"},returnType:"Color",desc:"Reads G channel of a Color.",code:"local G = color.read(color.RED)",metadata:{ThreadSafe:!0}}),(0,p.jsx)(t.A,{name:"b",fullName:"Color.b",params:{c:"Color"},returnType:"Color",desc:"Reads B channel of a Color.",code:"local B = color.read(color.RED)",metadata:{ThreadSafe:!0}}),(0,p.jsx)(t.A,{name:"a",fullName:"Color.a",params:{c:"Color"},returnType:"Color",desc:"Reads A channel of a Color.",code:"local A = color.read(color.RED)",metadata:{ThreadSafe:!0}}),(0,p.jsx)("div",{style:{height:"55px"}})]}),(0,p.jsx)(l.A,{}),(0,p.jsx)("div",{className:"grid-background-dark"})]})}}]);
//# sourceMappingURL=228.7627a63f.chunk.js.map