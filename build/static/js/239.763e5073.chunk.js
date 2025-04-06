/*! For license information please see 239.763e5073.chunk.js.LICENSE.txt */
"use strict";(self.webpackChunkreact_test=self.webpackChunkreact_test||[]).push([[239],{788:(e,n,a)=>{a.d(n,{A:()=>i});var t=a(5043),o=a(579);const i=e=>{let{links:n}=e;const[a,i]=(0,t.useState)(window.location.pathname);return(0,t.useEffect)((()=>{const e=()=>{i(window.location.pathname)};return window.addEventListener("popstate",e),()=>window.removeEventListener("popstate",e)}),[]),(0,o.jsx)("div",{className:"sidebar",children:n.map(((e,n)=>{const t=e.href,i=a===t;return(0,o.jsx)("a",{href:t,className:"sidebar-link",style:{color:i?"#446EE4":"#c2c7d6"},children:e.text},n)}))})}},2207:(e,n,a)=>{a.d(n,{ls:()=>x,FD:()=>g,qY:()=>y});var t=a(5043),o=a(3067);const i=(0,o.A)("bug",[["path",{d:"m8 2 1.88 1.88",key:"fmnt4t"}],["path",{d:"M14.12 3.88 16 2",key:"qol33r"}],["path",{d:"M9 7.13v-1a3.003 3.003 0 1 1 6 0v1",key:"d7y7pr"}],["path",{d:"M12 20c-3.3 0-6-2.7-6-6v-3a4 4 0 0 1 4-4h4a4 4 0 0 1 4 4v3c0 3.3-2.7 6-6 6",key:"xs1cw7"}],["path",{d:"M12 20v-9",key:"1qisl0"}],["path",{d:"M6.53 9C4.6 8.8 3 7.1 3 5",key:"32zzws"}],["path",{d:"M6 13H2",key:"82j7cp"}],["path",{d:"M3 21c0-2.1 1.7-3.9 3.8-4",key:"4p0ekp"}],["path",{d:"M20.97 5c0 2.1-1.6 3.8-3.5 4",key:"18gb23"}],["path",{d:"M22 13h-4",key:"1jl80f"}],["path",{d:"M17.2 17c2.1.1 3.8 1.9 3.8 4",key:"k3fwyw"}]]),s=(0,o.A)("check",[["path",{d:"M20 6 9 17l-5-5",key:"1gmf2c"}]]),r=(0,o.A)("triangle-alert",[["path",{d:"m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3",key:"wmoenq"}],["path",{d:"M12 9v4",key:"juzpu7"}],["path",{d:"M12 17h.01",key:"p32p05"}]]),l=(0,o.A)("flask-conical",[["path",{d:"M14 2v6a2 2 0 0 0 .245.96l5.51 10.08A2 2 0 0 1 18 22H6a2 2 0 0 1-1.755-2.96l5.51-10.08A2 2 0 0 0 10 8V2",key:"18mbvz"}],["path",{d:"M6.453 15h11.094",key:"3shlmq"}],["path",{d:"M8.5 2h7",key:"csnxdl"}]]),c=(0,o.A)("x",[["path",{d:"M18 6 6 18",key:"1bl5f8"}],["path",{d:"m6 6 12 12",key:"d8bk6v"}]]);var d=a(7574);const p=(0,o.A)("flame",[["path",{d:"M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z",key:"96xj49"}]]),h=[["path",{d:"M6 6 4.4 4.6A1.5 1.5 0 0 1 5.5 2h13a1.5 1.5 0 0 1 1.1 2.5L18 6",key:"ad6ouv"}],["rect",{width:"12",height:"12",x:"6",y:"6",key:"1aa27j"}],["path",{d:"m6 11 10-5",key:"1gsd7q"}],["path",{d:"M22 16v-3a4 4 0 0 0-4-4L6 15",key:"1syuiw"}],["path",{d:"m8 18 10-5",key:"2s28in"}],["path",{d:"m18 18 1.6 1.4a1.45 1.45 0 0 1-1.1 2.5h-13a1.5 1.5 0 0 1-1.1-2.5L6 18",key:"10pw92"}]],m=[{name:"Color",page:"/osgl/api/color#color"},{name:"Glyph",page:"/osgl/api/font#glyph"},{name:"Glyphs",page:"/osgl/api/font#glyphs"},{name:"StoredFont",page:"/osgl/api/font#storedfont"},{name:"BaseRawTexture",page:"/osgl/api/texture#baserawtexture"},{name:"BaseUnloadedTexture",page:"/osgl/api/texture#baseunloadedtexture"},{name:"RawTexture",page:"/osgl/api/texture#rawtexture"},{name:"TextureBase",page:"/osgl/api/window#texturebase"},{name:"ImageBase",page:"/osgl/api/window#imagebase"},{name:"Drawable",page:"/osgl/api/window#drawable"},{name:"TextureError",page:"/osgl/api/enum#textureerrors"},{name:"WindowError",page:"/osgl/api/enum#windowerrors"},{name:"DrawableError",page:"/osgl/api/enum#drawableerrors"},{name:"FontError",page:"/osgl/api/enum#fonterrors"}];var u=a(579);const g=e=>{if(e.includes("|"))return e.split("|").map((e=>g(e.trim()))).join(" | ");const n=(e=>{const n=e.match(/^(\{+)([A-Za-z0-9_]+)(\}+)$/);if(n){const[e,a,t,o]=n;return`${a}${g(t)}${o}`}return null})(e);if(n)return n;if(e.startsWith("..."))return"..."+g(e.substring(3,e.length));if(e.startsWith("Result<")){const n=e.indexOf(">"),a=e.substring(7,n),t=e.substring(n+1);return`<a href="/osgl/api/result" class="global">Result</a><${a.split(",").map((e=>g(e.trim()))).join(", ")}>${g(t)}`}for(const i of m)if(i.name===e)return`<a href="${i.page}" class="global">${i.name}</a>`;const a=e.split(/([<>])/);let t="",o=!1;return a.forEach((e=>{"<"===e||">"===e?(t+=e,o="<"===e):t+=o?e.split(",").map((e=>e.replace(/([A-Za-z0-9_]+)/g,'<span class="global">$1</span>'))).join(","):e.replace(/([A-Za-z0-9_]+)/g,'<span class="global">$1</span>')})),t},y=e=>(0,u.jsx)("span",{dangerouslySetInnerHTML:{__html:g(e)}}),x=e=>{let{functionName:n,params:a,returnType:o,isMethod:m,metadata:y={}}=e;const[x,f]=(0,t.useState)(null),[b,k]=(0,t.useState)(null),w=m?":":".",[v,j]=n.split(w),M=j?`${v}${w}<span style="color: #10ac84;">${j}</span>`:n,A=[{key:"Debug",display:"DEBUG",icon:(0,u.jsx)(i,{size:12}),tooltip:"Debug utilities (safe for production but primarily for diagnostics)"},{key:"Checked",display:"CHECKED",icon:(0,u.jsx)(s,{size:12}),tooltip:"Includes runtime validation - useful when you need bounds checking\n(Adds minimal performance overhead)"},{key:"Unchecked",display:"UNCHECKED",icon:(0,u.jsx)(r,{size:12}),tooltip:"No runtime validation - only use when absolutely certain of inputs\n(Marginally faster than checked versions)",warning:!0},{key:"Experimental",display:"EXPERIMENTAL",icon:(0,u.jsx)(l,{size:12}),tooltip:"API may change between minor versions\n(Use with caution in production)"},{key:"Deprecated",display:"DEPRECATED",icon:(0,u.jsx)(c,{size:12}),tooltip:"Will be removed in future versions\n(Migrate to newer alternatives)",warning:!0},{key:"ThreadSafe",display:"THREAD-SAFE",icon:(0,u.jsx)(d.A,{size:12,iconNode:h}),tooltip:"Can be called from any thread\n(No synchronization needed)",highlight:!0},{key:"HotPath",display:"HOT-PATH",icon:(0,u.jsx)(p,{size:12}),tooltip:"Optimized for performance-critical code\n(Avoid expensive operations in callbacks). Usually means no runtime validation."}];let E=Object.entries(a).map((e=>{let[n,a]=e,t="",o="";return"string"===typeof a?t=g(a):"object"===typeof a&&a.type&&(t=g(a.type),o=a.comment?(e=>`<span class="comment">${e}</span>`)(` -- ${a.comment}`):""),`    ${n}: ${t},${o}`})).join("\n");0!==E.length&&(E="\n"+E+"\n");const N=`${M}(${E}) -> ${g(o)};`;return(0,u.jsxs)("div",{className:"function-container",children:[(0,u.jsx)("div",{className:"metadata-flags",children:A.map((e=>y[e.key]&&(0,u.jsxs)("div",{className:`metadata-flag ${e.warning?"warning":""} ${e.highlight?"highlight":""}`,onMouseEnter:()=>{clearTimeout(b),f(e.key)},onMouseLeave:()=>{const e=setTimeout((()=>{f(null)}),150);k(e)},children:[(0,u.jsx)("span",{className:"flag-icon",children:e.icon}),(0,u.jsx)("span",{className:"flag-text",children:e.display}),(0,u.jsx)("div",{className:"custom-tooltip "+(x===e.key?"visible":""),children:e.tooltip.split("\n").map(((e,n)=>(0,u.jsx)("div",{children:e},n)))})]},e.key)))}),(0,u.jsx)("pre",{className:"output",dangerouslySetInnerHTML:{__html:N}}),(0,u.jsx)("style",{jsx:!0,children:'\n        .function-container {\n          position: relative;\n          margin: 1em 0;\n          font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;\n        }\n        .metadata-flags {\n          display: flex;\n          gap: 0.5em;\n          margin-bottom: 0.5em;\n          flex-wrap: wrap;\n          position: relative;\n        }\n        .metadata-flag {\n          position: relative;\n          padding: 0.3em 0.6em;\n          background: #2d3436;\n          color: #dfe6e9;\n          border-radius: 4px;\n          font-size: 0.8em;\n          font-weight: bold;\n          cursor: help;\n          display: flex;\n          align-items: center;\n          gap: 0.4em;\n        }\n        .metadata-flag.warning {\n          background: #d63031;\n          color: white;\n        }\n        .metadata-flag.highlight {\n          background: #C74949;\n          color: white;\n        }\n        .flag-icon {\n          display: flex;\n          margin-right: 0.2em;\n        }\n        .custom-tooltip {\n          position: absolute;\n          bottom: 100%;\n          left: 50%;\n          transform: translateX(-50%);\n          background: rgba(0, 0, 0, 0.9);\n          color: white;\n          padding: 0.8em;\n          border-radius: 4px;\n          font-size: 0.9em;\n          line-height: 1.4;\n          font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;\n          min-width: 260px;\n          max-width: 360px;\n          z-index: 100;\n          margin-bottom: 8px;\n          pointer-events: none;\n          opacity: 0;\n          transition: opacity 0.12s ease-out;\n          box-shadow: 0 2px 8px rgba(0,0,0,0.2);\n          white-space: pre-line;\n          text-align: left;\n        }\n        .custom-tooltip.visible {\n          opacity: 1;\n        }\n        .custom-tooltip::after {\n          content: \'\';\n          position: absolute;\n          top: 100%;\n          left: 50%;\n          transform: translateX(-50%);\n          border-width: 6px;\n          border-style: solid;\n          border-color: rgba(0, 0, 0, 0.9) transparent transparent transparent;\n        }\n      '})]})}},2840:(e,n,a)=>{a.d(n,{A:()=>m});var t=a(5043),o=a(3067);const i=(0,o.A)("network",[["rect",{x:"16",y:"16",width:"6",height:"6",rx:"1",key:"4q2zg0"}],["rect",{x:"2",y:"16",width:"6",height:"6",rx:"1",key:"8cvhb9"}],["rect",{x:"9",y:"2",width:"6",height:"6",rx:"1",key:"1egb70"}],["path",{d:"M5 16v-3a1 1 0 0 1 1-1h12a1 1 0 0 1 1 1v3",key:"1jsf9p"}],["path",{d:"M12 12V8",key:"2874zd"}]]),s=(0,o.A)("cpu",[["rect",{width:"16",height:"16",x:"4",y:"4",rx:"2",key:"14l7u7"}],["rect",{width:"6",height:"6",x:"9",y:"9",rx:"1",key:"5aljv4"}],["path",{d:"M15 2v2",key:"13l42r"}],["path",{d:"M15 20v2",key:"15mkzm"}],["path",{d:"M2 15h2",key:"1gxd5l"}],["path",{d:"M2 9h2",key:"1bbxkp"}],["path",{d:"M20 15h2",key:"19e6y8"}],["path",{d:"M20 9h2",key:"19tzq7"}],["path",{d:"M9 2v2",key:"165o2o"}],["path",{d:"M9 20v2",key:"i2bqo8"}]]),r=(0,o.A)("box",[["path",{d:"M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z",key:"hh9hay"}],["path",{d:"m3.3 7 8.7 5 8.7-5",key:"g66t2b"}],["path",{d:"M12 22V12",key:"d0xqtd"}]]),l=(0,o.A)("layers",[["path",{d:"M12.83 2.18a2 2 0 0 0-1.66 0L2.6 6.08a1 1 0 0 0 0 1.83l8.58 3.91a2 2 0 0 0 1.66 0l8.58-3.9a1 1 0 0 0 0-1.83z",key:"zw3jo"}],["path",{d:"M2 12a1 1 0 0 0 .58.91l8.6 3.91a2 2 0 0 0 1.65 0l8.58-3.9A1 1 0 0 0 22 12",key:"1wduqc"}],["path",{d:"M2 17a1 1 0 0 0 .58.91l8.6 3.91a2 2 0 0 0 1.65 0l8.58-3.9A1 1 0 0 0 22 17",key:"kqbvx6"}]]),c=(0,o.A)("package",[["path",{d:"M11 21.73a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16V8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73z",key:"1a0edw"}],["path",{d:"M12 22V12",key:"d0xqtd"}],["polyline",{points:"3.29 7 12 12 20.71 7",key:"ousv84"}],["path",{d:"m7.5 4.27 9 5.15",key:"1c824w"}]]),d=(0,o.A)("code",[["polyline",{points:"16 18 22 12 16 6",key:"z7tu5w"}],["polyline",{points:"8 6 2 12 8 18",key:"1eg1df"}]]),p=(0,o.A)("shield",[["path",{d:"M20 13c0 5-3.5 7.5-7.66 8.95a1 1 0 0 1-.67-.01C7.5 20.5 4 18 4 13V6a1 1 0 0 1 1-1c2 0 4.5-1.2 6.24-2.72a1.17 1.17 0 0 1 1.52 0C14.51 3.81 17 5 19 5a1 1 0 0 1 1 1z",key:"oel41y"}]]);var h=a(579);const m=e=>{let{metadata:n={}}=e;const[a,o]=(0,t.useState)(null),[m,u]=(0,t.useState)(null),g=[{key:"inherits",display:"INHERITS",icon:(0,h.jsx)(i,{size:12}),tooltip:n.inherits?`Inherits from: ${n.inherits.join(", ")}`:"No parent classes",condition:n.inherits&&n.inherits.length>0,color:"rgb(45, 52, 54)"},{key:"core",display:"CORE",icon:(0,h.jsx)(s,{size:12}),tooltip:"Core library module\n(Required for basic functionality)",condition:n.core,color:"rgb(45, 52, 54)"},{key:"abstract",display:"ABSTRACT",icon:(0,h.jsx)(r,{size:12}),tooltip:"Abstract base class\n(Cannot be instantiated directly)",condition:n.abstract,color:"rgb(45, 52, 54)"},{key:"composite",display:"COMPOSITE",icon:(0,h.jsx)(l,{size:12}),tooltip:"Contains other objects\n(Manages child components)",condition:n.composite,color:"rgb(45, 52, 54)"},{key:"singleton",display:"SINGLETON",icon:(0,h.jsx)(c,{size:12}),tooltip:"Single instance only",condition:n.singleton,color:"rgb(45, 52, 54)"},{key:"interface",display:"INTERFACE",icon:(0,h.jsx)(d,{size:12}),tooltip:"Pure interface\n(No implementation, only declarations)",condition:n.interface,color:"rgb(45, 52, 54)"},{key:"threadSafe",display:"THREAD-SAFE",icon:(0,h.jsx)(p,{size:12}),tooltip:"Can be passed between threads.",condition:n.threadSafe,color:"rgb(199, 73, 73)"},{key:"partialThreadSafe",display:"THREAD-SAFE*",icon:(0,h.jsx)(p,{size:12}),tooltip:"Can be passed between threads without issues (only through actor:SendMessage())",condition:n.partialThreadSafe,color:"rgb(199, 111, 73)"}];return(0,h.jsxs)("div",{className:"class-meta-container",children:[(0,h.jsx)("div",{className:"metadata-flags",children:g.map((e=>e.condition&&(0,h.jsxs)("div",{className:"metadata-flag",style:{background:e.color},onMouseEnter:()=>{clearTimeout(m),o(e.key)},onMouseLeave:()=>{const e=setTimeout((()=>{o(null)}),150);u(e)},children:[(0,h.jsx)("span",{className:"flag-icon",children:e.icon}),(0,h.jsx)("span",{className:"flag-text",children:e.display}),(0,h.jsx)("div",{className:"custom-tooltip "+(a===e.key?"visible":""),children:e.tooltip.split("\n").map(((e,n)=>(0,h.jsx)("div",{children:e},n)))})]},e.key)))}),(0,h.jsx)("style",{jsx:!0,children:'\n        .class-meta-container {\n          position: relative;\n          font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;\n        }\n        .metadata-flags {\n          display: flex;\n          gap: 0.5em;\n          margin-bottom: 0.5em;\n          flex-wrap: wrap;\n          position: relative;\n        }\n        .metadata-flag {\n          position: relative;\n          padding: 0.3em 0.6em;\n          color: white;\n          border-radius: 4px;\n          font-size: 0.8em;\n          font-weight: bold;\n          cursor: help;\n          display: flex;\n          align-items: center;\n          gap: 0.4em;\n        }\n        .flag-icon {\n          display: flex;\n          margin-right: 0.2em;\n        }\n        .custom-tooltip {\n          position: absolute;\n          bottom: 100%;\n          left: 50%;\n          transform: translateX(-50%);\n          background: rgba(0, 0, 0, 0.9);\n          color: white;\n          padding: 0.8em;\n          border-radius: 4px;\n          font-size: 0.9em;\n          line-height: 1.4;\n          font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace;\n          min-width: 260px;\n          max-width: 360px;\n          z-index: 100;\n          margin-bottom: 8px;\n          pointer-events: none;\n          opacity: 0;\n          transition: opacity 0.12s ease-out;\n          box-shadow: 0 2px 8px rgba(0,0,0,0.2);\n          white-space: pre-line;\n          text-align: left;\n        }\n        .custom-tooltip.visible {\n          opacity: 1;\n        }\n        .custom-tooltip::after {\n          content: \'\';\n          position: absolute;\n          top: 100%;\n          left: 50%;\n          transform: translateX(-50%);\n          border-width: 6px;\n          border-style: solid;\n          border-color: rgba(0, 0, 0, 0.9) transparent transparent transparent;\n        }\n      '})]})}},3774:()=>{},4221:(e,n,a)=>{a.d(n,{A:()=>s});var t=a(5043),o=a(7709),i=(a(8806),a(9006),a(579));const s=e=>{let{code:n,language:s="lua",filename:r}=e;(0,t.useEffect)((()=>{o.A.registerLanguage("lua",a(6092))}),[]);const[l,c]=(0,t.useState)(!1),d=(0,t.useRef)(null);(0,t.useEffect)((()=>{d.current&&o.A.highlightElement(d.current)}),[n]);return(0,i.jsxs)("div",{className:"code-block-container",children:[r&&(0,i.jsx)("div",{className:"filename",children:(0,i.jsx)("p",{className:"doc-paragraph",children:r})}),(0,i.jsx)("pre",{className:"code-block",children:(0,i.jsx)("code",{ref:d,className:`language-${s}`,children:n})}),(0,i.jsx)("button",{className:"copy-btn "+(l?"copied":""),onClick:()=>{navigator.clipboard.writeText(n).then((()=>{c(!0),setTimeout((()=>c(!1)),1500)})).catch((e=>console.error("Copy failed:",e)))},children:l?"Copied!":"Copy"})]})}},5613:()=>{},6261:(e,n,a)=>{a.d(n,{A:()=>r});var t=a(5043),o=a(2207),i=a(4221),s=a(579);const r=e=>{let{name:n,fullName:a,params:r,returnType:l,desc:c,code:d,isMethod:p,metadata:h}=e;const m=n.replace(/\s+/g,"-").toLowerCase();return(0,t.useEffect)((()=>{const e=()=>{if(window.location.hash===`#${m}`){const e=document.getElementById(m);e&&e.scrollIntoView({behavior:"smooth",block:"center"})}};return e(),window.addEventListener("hashchange",e),()=>{window.removeEventListener("hashchange",e)}}),[m]),(0,s.jsxs)("div",{children:[(0,s.jsx)("code",{id:m,className:"api-name-header",children:n}),(0,s.jsx)("br",{}),(0,s.jsx)(o.ls,{functionName:a,params:r,returnType:l,isMethod:p,metadata:h||{}}),(0,s.jsx)("p",{className:"api-paragraph",children:c}),d&&(0,s.jsx)(i.A,{code:d})]})}},6724:(e,n,a)=>{a.d(n,{A:()=>s});var t=a(5043),o=a(6904),i=a(579);const s=e=>{let{name:n,fullName:a,type:s,desc:r}=e;const l=n.replace(/\s+/g,"-").toLowerCase();return(0,t.useEffect)((()=>{const e=()=>{if(window.location.hash===`#${l}`){const e=document.getElementById(l);e&&e.scrollIntoView({behavior:"smooth",block:"center"})}};return e(),window.addEventListener("hashchange",e),()=>{window.removeEventListener("hashchange",e)}}),[l]),(0,i.jsxs)("div",{children:[(0,i.jsx)("code",{id:l,className:"api-name-header",children:n}),(0,i.jsx)("br",{}),(0,i.jsx)(o.A,{fullName:a,type:s,desc:r})]})}},6904:(e,n,a)=>{a.d(n,{A:()=>i});var t=a(2207),o=a(579);const i=e=>{let{fullName:n,type:a,desc:i}=e;return(0,o.jsxs)("div",{children:[(0,o.jsxs)("code",{className:"api-name-text",style:{whiteSpace:"nowrap"},children:[n,(0,o.jsx)("b",{children:": "}),(0,o.jsx)("span",{children:(0,t.qY)(a)})]}),(0,o.jsx)("p",{className:"api-paragraph",children:i})]})}},9006:()=>{}}]);
//# sourceMappingURL=239.763e5073.chunk.js.map