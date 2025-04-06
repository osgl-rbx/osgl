"use strict";(self.webpackChunkosgl_docs=self.webpackChunkosgl_docs||[]).push([[728],{282:()=>{},2355:()=>{},2987:(e,a,s)=>{s.d(a,{A:()=>n});var t=s(5043),i=s(579);const n=e=>{let{sections:a}=e;const[s,n]=(0,t.useState)({}),[l,c]=(0,t.useState)({}),[r,o]=(0,t.useState)(window.location.pathname);(0,t.useEffect)((()=>{const e=()=>{o(window.location.pathname)};return window.addEventListener("popstate",e),()=>window.removeEventListener("popstate",e)}),[]);return(0,i.jsx)("div",{className:"sidebar",children:a.map(((e,a)=>{const t=r.startsWith(`/${e.id}`);return(0,i.jsxs)("div",{className:"sidebar-section",children:[(0,i.jsxs)("div",{className:"section-header",onClick:()=>(e=>{s[e]?(c((a=>({...a,[e]:"fade-out"}))),setTimeout((()=>{n((a=>({...a,[e]:!1}))),c((a=>({...a,[e]:""})))}),300)):(n((a=>({...a,[e]:!0}))),c((a=>({...a,[e]:"fade-in"}))))})(e.title),children:[(0,i.jsx)("span",{style:{color:t?"#446EE4":"white"},children:e.title}),(0,i.jsx)("span",{className:"toggle-icon",style:{transform:s[e.title]?"rotate(90deg)":"rotate(0deg)"},children:"\u25ba"})]}),s[e.title]&&(0,i.jsx)("div",{className:`sub-sections ${l[e.title]}`,children:e.links.map(((e,a)=>{const s=r===e.href;return(0,i.jsx)("a",{href:e.href,className:"sub-section-link",style:{animationDelay:.1*a+"s",color:s?"#446EE4":"#c2c7d6"},children:e.text},a)}))})]},a)}))})}},3974:(e,a,s)=>{s.r(a),s.d(a,{default:()=>o});s(5043),s(9006);var t=s(929),i=s(8174),n=s(4221),l=(s(4533),s(2987)),c=(s(5762),s(6562),s(282),s(3371)),r=(s(2355),s(579));const o=()=>(0,r.jsxs)("div",{className:"Docs",children:[(0,r.jsx)("title",{children:"Docs | OSGL"}),(0,r.jsx)(i.A,{}),(0,r.jsx)("div",{className:"sidebar-content",children:(0,r.jsx)(l.A,{sections:c.A})}),(0,r.jsxs)("div",{className:"doc-content",children:[(0,r.jsx)("h1",{className:"doc-header",children:"Bitmaps"}),(0,r.jsx)("div",{className:"doc-header-line"}),(0,r.jsx)("h2",{className:"doc-header",children:"Overview"}),(0,r.jsx)("p",{className:"doc-paragraph",children:"Bitmaps are specialized textures that store pixel data with a variable number of channels. Unlike regular textures, bitmaps are specfically optimized for fast pixel access."}),(0,r.jsx)("h2",{className:"doc-header",children:"Creation"}),(0,r.jsx)("p",{className:"doc-paragraph",children:"Bitmaps are typically created from existing texture data:"}),(0,r.jsx)(n.A,{code:"local OSGL = require(path.to.OSGL)\nlocal Bitmap = require(OSGL.Bitmap)\n\nlocal textureModule = script.moduleThatReturnsTexture\n\nlocal bitmap = Bitmap.fromChecked(textureModule)"}),(0,r.jsx)("h2",{className:"doc-header",children:"Reading"}),(0,r.jsxs)("p",{className:"doc-paragraph",children:["The primary operation available for bitmaps is the ",(0,r.jsx)("code",{children:"Read"})," function:"]}),(0,r.jsx)(n.A,{code:"bitmap:Read(x: number, y: number, channel: number?): number"}),(0,r.jsx)("p",{className:"doc-paragraph",children:"The function reads a specific channel of a pixel, given the X and Y of that pixel. The channel is defaulted to the first one available (1), making its default behaviour similar to a mask. "}),(0,r.jsx)("h2",{className:"doc-header",children:"Writing"}),(0,r.jsxs)("p",{className:"doc-paragraph",children:["It is also possible to ",(0,r.jsx)("code",{children:"Write"})," to a Bitmap:"]}),(0,r.jsx)(n.A,{code:"bitmap:Write(x: number, y: number, channel: number, value: number): number"}),(0,r.jsx)("p",{className:"doc-paragraph",children:"The function writes to a specific channel of a pixel, given the X and Y of that pixel."}),(0,r.jsx)("h3",{className:"doc-header",children:"Examples"}),(0,r.jsx)(n.A,{code:"\n-- Read the first channel of the pixel at (2, 2)\n-- If this were a ABGR bitmap, it would return the value\n-- of the Alpha (first) channel.\nbitmap:Read(2, 2)\n\n-- Read the third channel of the pixel at (2, 2)\n-- If this were a RGBA bitmap, it would return the value\n-- of the Blue (third) channel.\nbitmap:Read(2, 2, 3)\n\n-- Write 255 to the 1st channel of the pixel at (2, 2)\nbitmap:Write(2, 2, 1, 255)"}),(0,r.jsx)("div",{style:{height:"55px"}})]}),(0,r.jsx)(t.A,{}),(0,r.jsx)("div",{className:"grid-background-dark"})]})},4221:(e,a,s)=>{s.d(a,{A:()=>l});var t=s(5043),i=s(7709),n=(s(8806),s(9006),s(579));const l=e=>{let{code:a,language:l="lua",filename:c}=e;(0,t.useEffect)((()=>{i.A.registerLanguage("lua",s(6092))}),[]);const[r,o]=(0,t.useState)(!1),d=(0,t.useRef)(null);(0,t.useEffect)((()=>{d.current&&i.A.highlightElement(d.current)}),[a]);return(0,n.jsxs)("div",{className:"code-block-container",children:[c&&(0,n.jsx)("div",{className:"filename",children:(0,n.jsx)("p",{className:"doc-paragraph",children:c})}),(0,n.jsx)("pre",{className:"code-block",children:(0,n.jsx)("code",{ref:d,className:`language-${l}`,children:a})}),(0,n.jsx)("button",{className:"copy-btn "+(r?"copied":""),onClick:()=>{navigator.clipboard.writeText(a).then((()=>{o(!0),setTimeout((()=>o(!1)),1500)})).catch((e=>console.error("Copy failed:",e)))},children:r?"Copied!":"Copy"})]})}},4533:(e,a,s)=>{s.d(a,{A:()=>n});var t=s(5043),i=s(579);const n=e=>{let{src:a,alt:s="Image",className:n=""}=e;const[l,c]=(0,t.useState)(!1),[r,o]=(0,t.useState)(!1);(0,t.useEffect)((()=>{l?setTimeout((()=>o(!0)),10):o(!1)}),[l]),(0,t.useEffect)((()=>{const e=e=>{"Escape"===e.key&&d()};return document.addEventListener("keydown",e),()=>document.removeEventListener("keydown",e)}),[]);const d=()=>{o(!1),setTimeout((()=>c(!1)),300)};return(0,i.jsxs)(i.Fragment,{children:[(0,i.jsx)("img",{src:"/osgl"+a,alt:s,className:`image-thumbnail ${n}`,onClick:()=>c(!0)}),l&&(0,i.jsx)("div",{className:"image-overlay "+(r?"visible":""),onClick:d,children:(0,i.jsxs)("div",{className:"image-container "+(r?"visible":""),onClick:e=>e.stopPropagation(),children:[(0,i.jsx)("button",{className:"close-button",onClick:d,children:"\u2715"}),(0,i.jsx)("img",{src:"/osgl"+a,alt:s,className:"enlarged-image"})]})})]})}},5762:()=>{},6562:()=>{},8174:(e,a,s)=>{s.d(a,{A:()=>l});s(5043);var t=s(6214),i=s(5351),n=s(579);const l=()=>(0,n.jsxs)("div",{className:"topbar",style:{height:"55px",position:"fixed"},children:[(0,n.jsx)(i.A,{name:"logo",link:"/osgl"}),(0,n.jsx)("div",{className:"docs-sig",children:(0,n.jsx)("img",{src:"/osgl/docs-colour.png",alt:"docs",className:"docs-img"})}),(0,n.jsx)("img",{src:"/osgl/logo-sep.png",alt:"Separator",className:"seperator-img",style:{marginLeft:"75px"}}),(0,n.jsx)(t.A,{name:"api",link:"/osgl/api"}),(0,n.jsx)(t.A,{name:"github",link:"https://github.com/osgl-rbx/osgl/"})]})},9006:()=>{}}]);
//# sourceMappingURL=728.263282c6.chunk.js.map