"use strict";(self.webpackChunkosgl_docs=self.webpackChunkosgl_docs||[]).push([[578],{282:()=>{},1172:(e,s,a)=>{a.r(s),a.d(s,{default:()=>d});a(5043),a(9006);var t=a(929),i=a(8174),n=a(4221),r=(a(4533),a(2987)),o=(a(5762),a(6562),a(282),a(3371)),c=(a(2355),a(579));const d=()=>(0,c.jsxs)("div",{className:"Docs",children:[(0,c.jsx)("title",{children:"Docs | OSGL"}),(0,c.jsx)(i.A,{}),(0,c.jsx)("div",{className:"sidebar-content",children:(0,c.jsx)(r.A,{sections:o.A})}),(0,c.jsxs)("div",{className:"doc-content",children:[(0,c.jsx)("h1",{className:"doc-header",children:"Multiple Renderers"}),(0,c.jsx)("div",{className:"doc-header-line"}),(0,c.jsxs)("p",{className:"doc-paragraph",children:[(0,c.jsx)("code",{children:"Window"}),"s can render to numerous instances simultaneously with minimal to no performance degradation. This capability is facilitated by the efficient management of renderers through the ",(0,c.jsx)("code",{children:"AddRenderers"})," and ",(0,c.jsx)("code",{children:"RemoveRenderers"})," methods. These methods enable addition and removal of renderers from the ",(0,c.jsx)("code",{children:"Window"})," during runtime."]}),(0,c.jsx)("h2",{className:"doc-header",children:"Adding a Renderer"}),(0,c.jsxs)("p",{className:"doc-paragraph",children:["To add a renderer to a ",(0,c.jsx)("code",{children:"Window"}),", utilize the ",(0,c.jsx)("code",{children:"AddRenderers"})," method. This method accepts a variadic list of Images as arguments and appends them to the ",(0,c.jsx)("code",{children:"Window"}),"'s renderer list. This allows the ",(0,c.jsx)("code",{children:"Window"})," to render multiple images concurrently."]}),(0,c.jsx)(n.A,{code:"window:AddRenderers(imageOne, imageTwo)"}),(0,c.jsx)("h2",{className:"doc-header",children:"Removing a Renderer"}),(0,c.jsxs)("p",{className:"doc-paragraph",children:["Conversely, to remove a renderer from a ",(0,c.jsx)("code",{children:"Window"}),", use the ",(0,c.jsx)("code",{children:"RemoveRenderers"})," method. This method also accepts a variadic list of Images as arguments. If the specified Images are currently being rendered by the ",(0,c.jsx)("code",{children:"Window"}),", they will be removed from the renderer list:"]}),(0,c.jsx)(n.A,{code:"window:RemoveRenderers(imageOne)"}),(0,c.jsx)("div",{style:{height:"55px"}})]}),(0,c.jsx)(t.A,{}),(0,c.jsx)("div",{className:"grid-background-dark"})]})},2355:()=>{},2987:(e,s,a)=>{a.d(s,{A:()=>n});var t=a(5043),i=a(579);const n=e=>{let{sections:s}=e;const[a,n]=(0,t.useState)({}),[r,o]=(0,t.useState)({}),[c,d]=(0,t.useState)(window.location.pathname+window.location.hash);(0,t.useEffect)((()=>{const e={};s.forEach((s=>{s.links.some((e=>c.startsWith(e.href)||c.startsWith(`#/${s.id}`)))&&(l(s.title),e[s.title]=!0)})),n(e);const a=()=>{const e=window.location.pathname+window.location.hash;d(e)};return window.addEventListener("popstate",a),()=>window.removeEventListener("popstate",a)}),[s]);const l=e=>{a[e]?(o((s=>({...s,[e]:"fade-out"}))),setTimeout((()=>{n((s=>({...s,[e]:!1}))),o((s=>({...s,[e]:""})))}),300)):(n((s=>({...s,[e]:!0}))),o((s=>({...s,[e]:"fade-in"}))))};return(0,i.jsx)("div",{className:"sidebar",children:s.map(((e,s)=>{const t=c.startsWith(`#/${e.id}`)||e.links.some((e=>c.startsWith(e.href)));return(0,i.jsxs)("div",{className:"sidebar-section",children:[(0,i.jsxs)("div",{className:"section-header",onClick:()=>l(e.title),children:[(0,i.jsx)("span",{style:{color:t?"#446EE4":"white"},children:e.title}),(0,i.jsx)("span",{className:"toggle-icon",style:{transform:a[e.title]?"rotate(90deg)":"rotate(0deg)"},children:"\u25b6"})]}),a[e.title]&&(0,i.jsx)("div",{className:`sub-sections ${r[e.title]}`,children:e.links.map(((e,s)=>{const a=c===e.href;return(0,i.jsx)("a",{href:e.href,className:"sub-section-link",style:{animationDelay:.1*s+"s",color:a?"#446EE4":"#c2c7d6"},children:e.text},s)}))})]},s)}))})}},4221:(e,s,a)=>{a.d(s,{A:()=>r});var t=a(5043),i=a(7709),n=(a(8806),a(9006),a(579));const r=e=>{let{code:s,language:r="lua",filename:o}=e;(0,t.useEffect)((()=>{i.A.registerLanguage("lua",a(6092))}),[]);const[c,d]=(0,t.useState)(!1),l=(0,t.useRef)(null);(0,t.useEffect)((()=>{l.current&&i.A.highlightElement(l.current)}),[s]);return(0,n.jsxs)("div",{className:"code-block-container",children:[o&&(0,n.jsx)("div",{className:"filename",children:(0,n.jsx)("p",{className:"doc-paragraph",children:o})}),(0,n.jsx)("pre",{className:"code-block",children:(0,n.jsx)("code",{ref:l,className:`language-${r}`,children:s})}),(0,n.jsx)("button",{className:"copy-btn "+(c?"copied":""),onClick:()=>{navigator.clipboard.writeText(s).then((()=>{d(!0),setTimeout((()=>d(!1)),1500)})).catch((e=>console.error("Copy failed:",e)))},children:c?"Copied!":"Copy"})]})}},4533:(e,s,a)=>{a.d(s,{A:()=>n});var t=a(5043),i=a(579);const n=e=>{let{src:s,alt:a="Image",className:n=""}=e;const[r,o]=(0,t.useState)(!1),[c,d]=(0,t.useState)(!1);(0,t.useEffect)((()=>{r?setTimeout((()=>d(!0)),10):d(!1)}),[r]),(0,t.useEffect)((()=>{const e=e=>{"Escape"===e.key&&l()};return document.addEventListener("keydown",e),()=>document.removeEventListener("keydown",e)}),[]);const l=()=>{d(!1),setTimeout((()=>o(!1)),300)};return(0,i.jsxs)(i.Fragment,{children:[(0,i.jsx)("img",{src:"/osgl"+s,alt:a,className:`image-thumbnail ${n}`,onClick:()=>o(!0)}),r&&(0,i.jsx)("div",{className:"image-overlay "+(c?"visible":""),onClick:l,children:(0,i.jsxs)("div",{className:"image-container "+(c?"visible":""),onClick:e=>e.stopPropagation(),children:[(0,i.jsx)("button",{className:"close-button",onClick:l,children:"\u2715"}),(0,i.jsx)("img",{src:"/osgl"+s,alt:a,className:"enlarged-image"})]})})]})}},5762:()=>{},6562:()=>{},8174:(e,s,a)=>{a.d(s,{A:()=>r});a(5043);var t=a(6214),i=a(5351),n=a(579);const r=()=>(0,n.jsxs)("div",{className:"topbar",style:{height:"55px",position:"fixed"},children:[(0,n.jsx)(i.A,{name:"logo",link:"/osgl"}),(0,n.jsx)("div",{className:"docs-sig",children:(0,n.jsx)("img",{src:"/osgl/docs-colour.png",alt:"docs",className:"docs-img"})}),(0,n.jsx)("img",{src:"/osgl/logo-sep.png",alt:"Separator",className:"seperator-img",style:{marginLeft:"75px"}}),(0,n.jsx)(t.A,{name:"api",link:"/osgl/#/api"}),(0,n.jsx)(t.A,{name:"github",link:"https://github.com/osgl-rbx/osgl/"})]})},9006:()=>{}}]);
//# sourceMappingURL=578.4f436b33.chunk.js.map