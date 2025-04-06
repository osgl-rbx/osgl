"use strict";(self.webpackChunkosgl_docs=self.webpackChunkosgl_docs||[]).push([[210],{282:()=>{},2355:()=>{},2987:(e,s,a)=>{a.d(s,{A:()=>r});var i=a(5043),n=a(579);const r=e=>{let{sections:s}=e;const[a,r]=(0,i.useState)({}),[t,o]=(0,i.useState)({}),[c,l]=(0,i.useState)(window.location.pathname+window.location.hash);(0,i.useEffect)((()=>{const e={};s.forEach((s=>{s.links.some((e=>c.startsWith(e.href)||c.startsWith(`#/${s.id}`)))&&(d(s.title),e[s.title]=!0)})),r(e);const a=()=>{const e=window.location.pathname+window.location.hash;l(e)};return window.addEventListener("popstate",a),()=>window.removeEventListener("popstate",a)}),[s]);const d=e=>{a[e]?(o((s=>({...s,[e]:"fade-out"}))),setTimeout((()=>{r((s=>({...s,[e]:!1}))),o((s=>({...s,[e]:""})))}),300)):(r((s=>({...s,[e]:!0}))),o((s=>({...s,[e]:"fade-in"}))))};return(0,n.jsx)("div",{className:"sidebar",children:s.map(((e,s)=>{const i=c.startsWith(`#/${e.id}`)||e.links.some((e=>c.startsWith(e.href)));return(0,n.jsxs)("div",{className:"sidebar-section",children:[(0,n.jsxs)("div",{className:"section-header",onClick:()=>d(e.title),children:[(0,n.jsx)("span",{style:{color:i?"#446EE4":"white"},children:e.title}),(0,n.jsx)("span",{className:"toggle-icon",style:{transform:a[e.title]?"rotate(90deg)":"rotate(0deg)"},children:"\u25b6"})]}),a[e.title]&&(0,n.jsx)("div",{className:`sub-sections ${t[e.title]}`,children:e.links.map(((e,s)=>{const a=c===e.href;return(0,n.jsx)("a",{href:e.href,className:"sub-section-link",style:{animationDelay:.1*s+"s",color:a?"#446EE4":"#c2c7d6"},children:e.text},s)}))})]},s)}))})}},4221:(e,s,a)=>{a.d(s,{A:()=>t});var i=a(5043),n=a(7709),r=(a(8806),a(9006),a(579));const t=e=>{let{code:s,language:t="lua",filename:o}=e;(0,i.useEffect)((()=>{n.A.registerLanguage("lua",a(6092))}),[]);const[c,l]=(0,i.useState)(!1),d=(0,i.useRef)(null);(0,i.useEffect)((()=>{d.current&&n.A.highlightElement(d.current)}),[s]);return(0,r.jsxs)("div",{className:"code-block-container",children:[o&&(0,r.jsx)("div",{className:"filename",children:(0,r.jsx)("p",{className:"doc-paragraph",children:o})}),(0,r.jsx)("pre",{className:"code-block",children:(0,r.jsx)("code",{ref:d,className:`language-${t}`,children:s})}),(0,r.jsx)("button",{className:"copy-btn "+(c?"copied":""),onClick:()=>{navigator.clipboard.writeText(s).then((()=>{l(!0),setTimeout((()=>l(!1)),1500)})).catch((e=>console.error("Copy failed:",e)))},children:c?"Copied!":"Copy"})]})}},4533:(e,s,a)=>{a.d(s,{A:()=>r});var i=a(5043),n=a(579);const r=e=>{let{src:s,alt:a="Image",className:r=""}=e;const[t,o]=(0,i.useState)(!1),[c,l]=(0,i.useState)(!1);(0,i.useEffect)((()=>{t?setTimeout((()=>l(!0)),10):l(!1)}),[t]),(0,i.useEffect)((()=>{const e=e=>{"Escape"===e.key&&d()};return document.addEventListener("keydown",e),()=>document.removeEventListener("keydown",e)}),[]);const d=()=>{l(!1),setTimeout((()=>o(!1)),300)};return(0,n.jsxs)(n.Fragment,{children:[(0,n.jsx)("img",{src:"/osgl"+s,alt:a,className:`image-thumbnail ${r}`,onClick:()=>o(!0)}),t&&(0,n.jsx)("div",{className:"image-overlay "+(c?"visible":""),onClick:d,children:(0,n.jsxs)("div",{className:"image-container "+(c?"visible":""),onClick:e=>e.stopPropagation(),children:[(0,n.jsx)("button",{className:"close-button",onClick:d,children:"\u2715"}),(0,n.jsx)("img",{src:"/osgl"+s,alt:a,className:"enlarged-image"})]})})]})}},5762:()=>{},6562:()=>{},7740:(e,s,a)=>{a.r(s),a.d(s,{default:()=>l});a(5043),a(9006);var i=a(929),n=a(8174),r=a(4221),t=(a(4533),a(2987)),o=(a(5762),a(6562),a(282),a(3371)),c=(a(2355),a(579));const l=()=>(0,c.jsxs)("div",{className:"Docs",children:[(0,c.jsx)("title",{children:"Docs | OSGL"}),(0,c.jsx)(n.A,{}),(0,c.jsx)("div",{className:"sidebar-content",children:(0,c.jsx)(t.A,{sections:o.A})}),(0,c.jsxs)("div",{className:"doc-content",children:[(0,c.jsx)("h1",{className:"doc-header",children:"Serializing & Deserializing"}),(0,c.jsx)("div",{className:"doc-header-line"}),(0,c.jsxs)("p",{className:"doc-paragraph",children:["OSGL simplifies the process of saving and loading your ",(0,c.jsx)("code",{children:"Window"}),"s and ",(0,c.jsx)("a",{className:"doc-paragraph",href:"/osgl/#/docs/textures/loading",children:"Textures"})," without encountering ",(0,c.jsx)("code",{children:"buffer"})," errors. This process, known as ",(0,c.jsx)("b",{className:"doc-paragraph",children:"serialization"})," and ",(0,c.jsx)("b",{className:"doc-paragraph",children:"deserialization"}),", ensures smooth data transfer."]}),(0,c.jsx)("h3",{className:"doc-header",children:"Why Serialize and Deserialize?"}),(0,c.jsxs)("p",{className:"doc-paragraph",children:["Consider a scenario where you have two ",(0,c.jsx)("code",{children:"Window"}),"s: Window A and Window B. You want to copy the contents of ",(0,c.jsx)("code",{children:"A"})," into ",(0,c.jsx)("code",{children:"B"}),". Typically, you might do something like this:"]}),(0,c.jsx)(r.A,{code:"local B = Window.fromBuffer(A.buffer, width, height)"}),(0,c.jsxs)("p",{className:"doc-paragraph",children:["However, if ",(0,c.jsx)("code",{children:"B"})," is not the same size as ",(0,c.jsx)("code",{children:"A"}),", an error will occur. This is where ",(0,c.jsx)("b",{className:"doc-paragraph",children:"serialization"})," and ",(0,c.jsx)("b",{className:"doc-paragraph",children:"deserialization"})," become useful. You can ",(0,c.jsx)("b",{className:"doc-paragraph",children:"serialize"})," a ",(0,c.jsx)("code",{children:"Window"})," and ",(0,c.jsx)("b",{className:"doc-paragraph",children:"deserialize"})," it into another ",(0,c.jsx)("code",{children:"Window"})," or even a ",(0,c.jsx)("code",{children:"Texture"}),":"]}),(0,c.jsx)(r.A,{code:"local A = Window.from(parent, 50, 50):Unwrap()\n\n-- Draw a texture to `A`\nlocal txt = Texture.fromAssetId(14419725604):Unwrap()\nTexture.drawChecked(A, txt, 0, 0)\n\n-- Serialize `A` to get its buffer, width, and height\nlocal bfr, w, h = A:Serialize()\n\nlocal B = Window.from(parentTwo, 2, 10):Unwrap()\n\n-- Resize `B` to match `A`'s dimensions and paste the contents\nB:Deserialize(bfr, w, h)\n\n-- Now `B` has the same size and contents as `A`\nB:Render()"}),(0,c.jsx)("h3",{className:"doc-header",children:"Understanding the Difference"}),(0,c.jsxs)("p",{className:"doc-paragraph",children:["If you are certain about the sizes of the ",(0,c.jsx)("code",{children:"Window"}),"s, you can use ",(0,c.jsx)("code",{children:"fromBuffer"}),". However, if you are unsure or need to resize dynamically, it is advisable to use ",(0,c.jsx)("code",{children:"Deserialize"}),". The ",(0,c.jsx)("code",{children:"Deserialize"})," function safely scales the size of the buffer. Directly setting the ",(0,c.jsx)("code",{children:"buffer"})," to another buffer may cause size errors! It's always safer to use ",(0,c.jsx)("code",{children:"Deserialize"}),", however if you are confident that both ",(0,c.jsx)("code",{children:"buffer"}),"s will always be the same size, you can directly set the buffer via:"]}),(0,c.jsx)(r.A,{code:"A.buffer = B.buffer"}),(0,c.jsx)("h3",{className:"doc-header",children:"Serializing Textures"}),(0,c.jsxs)("p",{className:"doc-paragraph",children:[(0,c.jsx)("code",{children:"Texture"}),"s can also be serialized:"]}),(0,c.jsx)(r.A,{code:"local txt = texture.fromAssetId(14419725604)\nlocal bfr, w, h = txt:Serialize()\n\n-- Create a new window with the texture's contents\nlocal window = Window.fromBuffer(bfr, w, h):Unwrap()\n\n-- Alternatively, use `Deserialize` to update an existing window:\nlocal secondWindow = -- *reference to a window*\nsecondWindow:Deserialize(bfr, w, h)"}),(0,c.jsx)("h3",{className:"doc-header",children:"Saving and Loading Example"}),(0,c.jsxs)("p",{className:"doc-paragraph",children:["Here is an example of how you can save and load the state of a ",(0,c.jsx)("code",{children:"Window"})," using serialization and deserialization:"]}),(0,c.jsx)(r.A,{code:"-- Save.luau\nlocal bfr, width, height = windowOne:Serialize()\n-- *save data*\n\n-- Load.luau\nlocal bfr, width, height = -- *load data*\nwindowTwo:Deserialize(bfr, width, height)"}),(0,c.jsxs)("p",{className:"doc-paragraph",children:["In summary, while serialization and deserialization are powerful functions for managing ",(0,c.jsx)("code",{children:"Window"}),"s and ",(0,c.jsx)("code",{children:"Texture"}),"s, there are times when directly setting the buffer with ",(0,c.jsx)("code",{children:"A.buffer = B.buffer"})," might be more convenient. This approach can be useful when you are certain that the sizes of the buffers match, as it avoids the need to handle potential performance issues / resizing issues that come with deserialization."]}),(0,c.jsx)("div",{style:{height:"55px"}})]}),(0,c.jsx)(i.A,{}),(0,c.jsx)("div",{className:"grid-background-dark"})]})},8174:(e,s,a)=>{a.d(s,{A:()=>t});a(5043);var i=a(6214),n=a(5351),r=a(579);const t=()=>(0,r.jsxs)("div",{className:"topbar",style:{height:"55px",position:"fixed"},children:[(0,r.jsx)(n.A,{name:"logo",link:"/osgl"}),(0,r.jsx)("div",{className:"docs-sig",children:(0,r.jsx)("img",{src:"/osgl/docs-colour.png",alt:"docs",className:"docs-img"})}),(0,r.jsx)("img",{src:"/osgl/logo-sep.png",alt:"Separator",className:"seperator-img",style:{marginLeft:"75px"}}),(0,r.jsx)(i.A,{name:"api",link:"/osgl/#/api"}),(0,r.jsx)(i.A,{name:"github",link:"https://github.com/osgl-rbx/osgl/"})]})},9006:()=>{}}]);
//# sourceMappingURL=210.b3b40aec.chunk.js.map