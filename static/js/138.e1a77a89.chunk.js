"use strict";(self.webpackChunkosgl_docs=self.webpackChunkosgl_docs||[]).push([[138],{282:()=>{},2355:()=>{},2987:(e,a,s)=>{s.d(a,{A:()=>i});var r=s(5043),c=s(579);const i=e=>{let{sections:a}=e;const[s,i]=(0,r.useState)({}),[l,t]=(0,r.useState)({}),[o,n]=(0,r.useState)(window.location.pathname);(0,r.useEffect)((()=>{const e=()=>{n(window.location.pathname)};return window.addEventListener("popstate",e),()=>window.removeEventListener("popstate",e)}),[]);return(0,c.jsx)("div",{className:"sidebar",children:a.map(((e,a)=>{const r=o.startsWith(`/${e.id}`);return(0,c.jsxs)("div",{className:"sidebar-section",children:[(0,c.jsxs)("div",{className:"section-header",onClick:()=>(e=>{s[e]?(t((a=>({...a,[e]:"fade-out"}))),setTimeout((()=>{i((a=>({...a,[e]:!1}))),t((a=>({...a,[e]:""})))}),300)):(i((a=>({...a,[e]:!0}))),t((a=>({...a,[e]:"fade-in"}))))})(e.title),children:[(0,c.jsx)("span",{style:{color:r?"#446EE4":"white"},children:e.title}),(0,c.jsx)("span",{className:"toggle-icon",style:{transform:s[e.title]?"rotate(90deg)":"rotate(0deg)"},children:"\u25ba"})]}),s[e.title]&&(0,c.jsx)("div",{className:`sub-sections ${l[e.title]}`,children:e.links.map(((e,a)=>{const s=o===e.href;return(0,c.jsx)("a",{href:e.href,className:"sub-section-link",style:{animationDelay:.1*a+"s",color:s?"#446EE4":"#c2c7d6"},children:e.text},a)}))})]},a)}))})}},4221:(e,a,s)=>{s.d(a,{A:()=>l});var r=s(5043),c=s(7709),i=(s(8806),s(9006),s(579));const l=e=>{let{code:a,language:l="lua",filename:t}=e;(0,r.useEffect)((()=>{c.A.registerLanguage("lua",s(6092))}),[]);const[o,n]=(0,r.useState)(!1),d=(0,r.useRef)(null);(0,r.useEffect)((()=>{d.current&&c.A.highlightElement(d.current)}),[a]);return(0,i.jsxs)("div",{className:"code-block-container",children:[t&&(0,i.jsx)("div",{className:"filename",children:(0,i.jsx)("p",{className:"doc-paragraph",children:t})}),(0,i.jsx)("pre",{className:"code-block",children:(0,i.jsx)("code",{ref:d,className:`language-${l}`,children:a})}),(0,i.jsx)("button",{className:"copy-btn "+(o?"copied":""),onClick:()=>{navigator.clipboard.writeText(a).then((()=>{n(!0),setTimeout((()=>n(!1)),1500)})).catch((e=>console.error("Copy failed:",e)))},children:o?"Copied!":"Copy"})]})}},4533:(e,a,s)=>{s.d(a,{A:()=>i});var r=s(5043),c=s(579);const i=e=>{let{src:a,alt:s="Image",className:i=""}=e;const[l,t]=(0,r.useState)(!1),[o,n]=(0,r.useState)(!1);(0,r.useEffect)((()=>{l?setTimeout((()=>n(!0)),10):n(!1)}),[l]),(0,r.useEffect)((()=>{const e=e=>{"Escape"===e.key&&d()};return document.addEventListener("keydown",e),()=>document.removeEventListener("keydown",e)}),[]);const d=()=>{n(!1),setTimeout((()=>t(!1)),300)};return(0,c.jsxs)(c.Fragment,{children:[(0,c.jsx)("img",{src:"/osgl"+a,alt:s,className:`image-thumbnail ${i}`,onClick:()=>t(!0)}),l&&(0,c.jsx)("div",{className:"image-overlay "+(o?"visible":""),onClick:d,children:(0,c.jsxs)("div",{className:"image-container "+(o?"visible":""),onClick:e=>e.stopPropagation(),children:[(0,c.jsx)("button",{className:"close-button",onClick:d,children:"\u2715"}),(0,c.jsx)("img",{src:"/osgl"+a,alt:s,className:"enlarged-image"})]})})]})}},5762:()=>{},6562:()=>{},8174:(e,a,s)=>{s.d(a,{A:()=>l});s(5043);var r=s(6214),c=s(5351),i=s(579);const l=()=>(0,i.jsxs)("div",{className:"topbar",style:{height:"55px",position:"fixed"},children:[(0,i.jsx)(c.A,{name:"logo",link:"/osgl"}),(0,i.jsx)("div",{className:"docs-sig",children:(0,i.jsx)("img",{src:"/osgl/docs-colour.png",alt:"docs",className:"docs-img"})}),(0,i.jsx)("img",{src:"/osgl/logo-sep.png",alt:"Separator",className:"seperator-img",style:{marginLeft:"75px"}}),(0,i.jsx)(r.A,{name:"api",link:"/osgl/api"}),(0,i.jsx)(r.A,{name:"github",link:"https://github.com/osgl-rbx/osgl/"})]})},9006:()=>{},9844:(e,a,s)=>{s.r(a),s.d(a,{default:()=>o});s(5043),s(9006);var r=s(929),c=s(8174),i=(s(4221),s(4533),s(2987)),l=(s(5762),s(6562),s(282),s(3371)),t=(s(2355),s(579));const o=()=>(0,t.jsxs)("div",{className:"Docs",children:[(0,t.jsx)("title",{children:"Docs | OSGL"}),(0,t.jsx)(c.A,{}),(0,t.jsx)("div",{className:"sidebar-content",children:(0,t.jsx)(i.A,{sections:l.A})}),(0,t.jsxs)("div",{className:"doc-content",children:[(0,t.jsx)("h1",{className:"doc-header",children:"Introduction"}),(0,t.jsx)("h2",{className:"doc-header",children:"About"}),(0,t.jsx)("div",{className:"doc-header-line"}),(0,t.jsxs)("p",{className:"doc-paragraph",children:["Welcome! This tutorial will introduce you to the basics of using the ",(0,t.jsx)("b",{className:"doc-paragraph",children:"OSGL"})," (Open-Source-Graphical-Library) API. OSGL provides a high-level abstraction of Roblox's ",(0,t.jsx)("a",{className:"doc-paragraph",href:"https://create.roblox.com/docs/reference/engine/classes/EditableImage",children:"EditableImage"})," API, offering direct pixel manipulation with excellent performance characteristics."]}),(0,t.jsxs)("p",{className:"doc-paragraph",children:["While other graphics solutions like ",(0,t.jsx)("a",{className:"doc-paragraph",href:"https://devforum.roblox.com/t/canvasdraw-a-powerful-pixel-based-graphics-library-draw-pixels-lines-triangles-readmodify-image-data-and-much-more/1624633",children:"CanvasDraw"})," provide different approaches to graphics rendering, OSGL focuses on delivering maximum performance through direct buffer access. This power comes with responsibility - improper use can lead to errors, but careful programming yields great results."]}),(0,t.jsx)("p",{className:"doc-paragraph",children:"Key features include:"}),(0,t.jsxs)("ul",{children:[(0,t.jsx)("p",{className:"doc-paragraph",children:" - Direct pixel manipulation capabilities"}),(0,t.jsxs)("p",{className:"doc-paragraph",children:[" - Built-in developer tools like the ",(0,t.jsx)("code",{children:"image-converter"})," utility"]}),(0,t.jsx)("p",{className:"doc-paragraph",children:" - High-performance rendering pipeline"}),(0,t.jsx)("p",{className:"doc-paragraph",children:" - Flexible architecture for advanced use cases"})]}),(0,t.jsx)("h3",{className:"doc-header",children:"Prerequisites:"}),(0,t.jsxs)("ul",{children:[(0,t.jsxs)("p",{className:"doc-paragraph",children:[" - ",(0,t.jsx)("a",{className:"doc-paragraph",href:"https://create.roblox.com",children:"Roblox Studio & Account"})]}),(0,t.jsxs)("p",{className:"doc-paragraph",children:[" - ",(0,t.jsx)("a",{className:"doc-paragraph",href:"https://luau.org",children:"Basic Luau knowledge"})]}),(0,t.jsx)("p",{className:"doc-paragraph",children:" - Familiarity with graphics concepts (helpful but not required)"})]}),(0,t.jsxs)("p",{className:"doc-paragraph",children:["Code examples are available in the repository's ",(0,t.jsx)("code",{children:"examples"})," folder."]}),(0,t.jsx)("h2",{className:"doc-header",children:"Tutorial Structure"}),(0,t.jsxs)("ol",{children:[(0,t.jsxs)("p",{className:"doc-paragraph",children:[" - ",(0,t.jsx)("b",{className:"doc-paragraph",children:"Setup"})," - Installing and configuring OSGL"]}),(0,t.jsxs)("p",{className:"doc-paragraph",children:[" - ",(0,t.jsx)("b",{className:"doc-paragraph",children:"Windows"})," - Creating and managing render surfaces"]}),(0,t.jsxs)("p",{className:"doc-paragraph",children:[" - ",(0,t.jsx)("b",{className:"doc-paragraph",children:"Textures"})," - Loading and displaying images"]}),(0,t.jsxs)("p",{className:"doc-paragraph",children:[" - ",(0,t.jsx)("b",{className:"doc-paragraph",children:"Video"})," - Playback and rendering techniques"]}),(0,t.jsxs)("p",{className:"doc-paragraph",children:[" - ",(0,t.jsx)("b",{className:"doc-paragraph",children:"Fonts"})," - Font rendering"]}),(0,t.jsxs)("p",{className:"doc-paragraph",children:[" - ",(0,t.jsx)("b",{className:"doc-paragraph",children:"Internals"})," - Architecture and advanced customization"]})]}),(0,t.jsx)("p",{className:"doc-paragraph",children:"By completing this tutorial, you'll gain practical experience with OSGL's core features."}),(0,t.jsxs)("div",{class:"note",children:[(0,t.jsx)("div",{class:"note-title",children:"NOTE"}),(0,t.jsxs)("div",{class:"note-body",children:["OSGL is a community-driven project. We welcome contributions and feedback! You can submit issues or PRs via",(0,t.jsx)("a",{className:"doc-paragraph",href:"https://github.com/osgl-rbx/osgl",children:" GitHub"}),", review the ",(0,t.jsx)("a",{className:"doc-paragraph",href:"https://github.com/osgl-rbx/osgl/blob/main/CONTRIBUTING.md",children:"contribution guidelines "}),"and watch the repo for general updates."]})]}),(0,t.jsx)("div",{style:{height:"55px"}})]}),(0,t.jsx)(r.A,{}),(0,t.jsx)("div",{className:"grid-background-dark"})]})}}]);
//# sourceMappingURL=138.e1a77a89.chunk.js.map