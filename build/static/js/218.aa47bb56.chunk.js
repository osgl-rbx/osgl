"use strict";(self.webpackChunkreact_test=self.webpackChunkreact_test||[]).push([[218],{282:()=>{},1484:(e,a,s)=>{s.r(a),s.d(a,{default:()=>l});s(5043),s(9006);var n=s(929),o=s(8174),r=s(4221),i=(s(4533),s(2987)),t=(s(5762),s(6562),s(282),s(3371)),c=(s(2355),s(579));const l=()=>(0,c.jsxs)("div",{className:"Docs",children:[(0,c.jsx)("title",{children:"Docs | OSGL"}),(0,c.jsx)(o.A,{}),(0,c.jsx)("div",{className:"sidebar-content",children:(0,c.jsx)(i.A,{sections:t.A})}),(0,c.jsxs)("div",{className:"doc-content",children:[(0,c.jsx)("h1",{className:"doc-header",children:"Migration"}),(0,c.jsx)("div",{className:"doc-header-line"}),(0,c.jsx)("p",{className:"doc-paragraph",children:"Welcome to the migration guide for transitioning from CanvasDraw to OSGL. This guide will walk you through the key steps and changes needed to migrate your existing codebase smoothly from CanvasDraw to OSGL."}),(0,c.jsx)("p",{className:"doc-paragraph",children:"It's important to note that OSGL and CanvasDraw have different internal architectures. OSGL works differently from CanvasDraw, so you may need to refactor your code."}),(0,c.jsxs)("p",{className:"doc-paragraph",children:["In CanvasDraw, you create objects known as canvases with ",(0,c.jsx)("code",{children:"CanvasDraw.new()"}),". In OSGL, you create a ",(0,c.jsx)("b",{className:"doc-paragraph",children:"window"}),", which you can read about ",(0,c.jsx)("a",{className:"doc-paragraph",href:"/osgl/docs/introduction/rendering-to-a-window",children:"here"}),":"]}),(0,c.jsx)(r.A,{code:"local CanvasDraw = require(path)\nlocal OSGL = require(path)\nlocal Window = OSGL.Window -- OSGL is broken down into sub-modules that handle different aspects\n\n-- CanvasDraw\nCanvasDraw.new(Parent, Resolution, Color, Blur)\n\n-- OSGL\nWindow.from(Parent, width, height):Unwrap()"}),(0,c.jsxs)("p",{className:"doc-paragraph",children:["You can use the ",(0,c.jsx)("code",{children:"Window.from"})," function to create the equivalent of a CanvasDraw canvas in OSGL. The OSGL code creates an EditableImage of size ",(0,c.jsx)("code",{children:"(width, height)"}),"."]}),(0,c.jsxs)("p",{className:"doc-paragraph",children:["All drawing methods can be directly accessed from the ",(0,c.jsx)("code",{children:"Canvas"})," object in CanvasDraw. This is mostly the same in OSGL, though some drawing is handled by different sub-modules (e.g., drawing textures, etc.). Here is a comparison example:"]}),(0,c.jsx)(r.A,{code:"local CanvasDraw = require(path)\nlocal OSGL = require(path)\n\nlocal Window = OSGL.Window\nlocal color = OSGL.color\n\n-- Draw a red pixel\nlocal Canvas = CanvasDraw.new(Frame, Vector2.new(150, 100))\nCanvas:DrawPixel(Vector2.new(75, 50), Color3.new(1, 0, 0))\n\n-- Draw a red pixel\nlocal window = Window.from(Frame, 150, 100)\nwindow:Pixel(76, 51, color.RED)"}),(0,c.jsx)("p",{className:"doc-paragraph",children:"It's also important to note that in OSGL, the top-left corner of the window is (0, 0). In CanvasDraw, it is (1,1). This would mean looping over every pixel in the window would look something like:"}),(0,c.jsx)(r.A,{code:"for y = 0, height - 1 do\n    for x = 0, width - 1 do\n        -- do something\n    end\nend"}),(0,c.jsx)("p",{className:"doc-paragraph",children:"Similar to CanvasDraw, you can draw any shape via method:"}),(0,c.jsx)(r.A,{code:"local Canvas = CanvasDraw.new(Frame, Vector2.new(150, 100))\nCanvas:DrawPixel(Vector2.new(75, 50), Color3.new(1, 0, 0))\nCanvas:DrawLine(Vector2.new(5, 5), Vector2.new(145, 95), Color3.new(1, 0, 0), 2, true)\n\nlocal window = Window.new(Frame, { sizeX = 150, sizeY = 100 })\nwindow:Pixel(76, 51, color.RED)\nwindow:Line(6, 6, 146, 96, color.RED)"}),(0,c.jsxs)("p",{className:"doc-paragraph",children:["You can find more about these methods in the ",(0,c.jsx)("a",{className:"doc-paragraph",href:"/osgl/api/drawable-object",children:"API"}),"."]}),(0,c.jsxs)("p",{className:"doc-paragraph",children:["Both ",(0,c.jsx)("code",{children:"Window"}),"s and ",(0,c.jsx)("code",{children:"Texture"}),"s are known as ",(0,c.jsx)("code",{children:"DrawableObject"}),"s. A ",(0,c.jsx)("code",{children:"Window"})," is a special form of a ",(0,c.jsx)("code",{children:"Texture"}),", and a ",(0,c.jsx)("code",{children:"Texture"})," is a ",(0,c.jsx)("code",{children:"buffer"})," containing pixel data. This is similar to CanvasDraw's ",(0,c.jsx)("code",{children:"ImageData"}),". To save a texture, save the ",(0,c.jsx)("code",{children:"buffer"}),", ",(0,c.jsx)("code",{children:"width"}),", and ",(0,c.jsx)("code",{children:"height"})," (or just the ",(0,c.jsx)("code",{children:"size"}),"). Since it's a ",(0,c.jsx)("code",{children:"Texture"}),", you can load it back into the game. This process is described in ",(0,c.jsx)("a",{className:"doc-paragraph",href:"/osgl/docs/advanced/serialization",children:"Serialization and Deserialization"}),"."]}),(0,c.jsx)("div",{style:{height:"55px"}})]}),(0,c.jsx)(n.A,{}),(0,c.jsx)("div",{className:"grid-background-dark"})]})},2355:()=>{},2987:(e,a,s)=>{s.d(a,{A:()=>r});var n=s(5043),o=s(579);const r=e=>{let{sections:a}=e;const[s,r]=(0,n.useState)({}),[i,t]=(0,n.useState)({}),[c,l]=(0,n.useState)(window.location.pathname);(0,n.useEffect)((()=>{const e=()=>{l(window.location.pathname)};return window.addEventListener("popstate",e),()=>window.removeEventListener("popstate",e)}),[]);return(0,o.jsx)("div",{className:"sidebar",children:a.map(((e,a)=>{const n=c.startsWith(`/${e.id}`);return(0,o.jsxs)("div",{className:"sidebar-section",children:[(0,o.jsxs)("div",{className:"section-header",onClick:()=>(e=>{s[e]?(t((a=>({...a,[e]:"fade-out"}))),setTimeout((()=>{r((a=>({...a,[e]:!1}))),t((a=>({...a,[e]:""})))}),300)):(r((a=>({...a,[e]:!0}))),t((a=>({...a,[e]:"fade-in"}))))})(e.title),children:[(0,o.jsx)("span",{style:{color:n?"#446EE4":"white"},children:e.title}),(0,o.jsx)("span",{className:"toggle-icon",style:{transform:s[e.title]?"rotate(90deg)":"rotate(0deg)"},children:"\u25ba"})]}),s[e.title]&&(0,o.jsx)("div",{className:`sub-sections ${i[e.title]}`,children:e.links.map(((e,a)=>{const s=c===e.href;return(0,o.jsx)("a",{href:e.href,className:"sub-section-link",style:{animationDelay:.1*a+"s",color:s?"#446EE4":"#c2c7d6"},children:e.text},a)}))})]},a)}))})}},4221:(e,a,s)=>{s.d(a,{A:()=>i});var n=s(5043),o=s(7709),r=(s(8806),s(9006),s(579));const i=e=>{let{code:a,language:i="lua",filename:t}=e;(0,n.useEffect)((()=>{o.A.registerLanguage("lua",s(6092))}),[]);const[c,l]=(0,n.useState)(!1),d=(0,n.useRef)(null);(0,n.useEffect)((()=>{d.current&&o.A.highlightElement(d.current)}),[a]);return(0,r.jsxs)("div",{className:"code-block-container",children:[t&&(0,r.jsx)("div",{className:"filename",children:(0,r.jsx)("p",{className:"doc-paragraph",children:t})}),(0,r.jsx)("pre",{className:"code-block",children:(0,r.jsx)("code",{ref:d,className:`language-${i}`,children:a})}),(0,r.jsx)("button",{className:"copy-btn "+(c?"copied":""),onClick:()=>{navigator.clipboard.writeText(a).then((()=>{l(!0),setTimeout((()=>l(!1)),1500)})).catch((e=>console.error("Copy failed:",e)))},children:c?"Copied!":"Copy"})]})}},4533:(e,a,s)=>{s.d(a,{A:()=>r});var n=s(5043),o=s(579);const r=e=>{let{src:a,alt:s="Image",className:r=""}=e;const[i,t]=(0,n.useState)(!1),[c,l]=(0,n.useState)(!1);(0,n.useEffect)((()=>{i?setTimeout((()=>l(!0)),10):l(!1)}),[i]),(0,n.useEffect)((()=>{const e=e=>{"Escape"===e.key&&d()};return document.addEventListener("keydown",e),()=>document.removeEventListener("keydown",e)}),[]);const d=()=>{l(!1),setTimeout((()=>t(!1)),300)};return(0,o.jsxs)(o.Fragment,{children:[(0,o.jsx)("img",{src:"/osgl"+a,alt:s,className:`image-thumbnail ${r}`,onClick:()=>t(!0)}),i&&(0,o.jsx)("div",{className:"image-overlay "+(c?"visible":""),onClick:d,children:(0,o.jsxs)("div",{className:"image-container "+(c?"visible":""),onClick:e=>e.stopPropagation(),children:[(0,o.jsx)("button",{className:"close-button",onClick:d,children:"\u2715"}),(0,o.jsx)("img",{src:"/osgl"+a,alt:s,className:"enlarged-image"})]})})]})}},5762:()=>{},6562:()=>{},8174:(e,a,s)=>{s.d(a,{A:()=>i});s(5043);var n=s(6214),o=s(5351),r=s(579);const i=()=>(0,r.jsxs)("div",{className:"topbar",style:{height:"55px",position:"fixed"},children:[(0,r.jsx)(o.A,{name:"logo",link:"/osgl"}),(0,r.jsx)("div",{className:"docs-sig",children:(0,r.jsx)("img",{src:"/osgl/docs-colour.png",alt:"docs",className:"docs-img"})}),(0,r.jsx)("img",{src:"/osgl/logo-sep.png",alt:"Separator",className:"seperator-img",style:{marginLeft:"75px"}}),(0,r.jsx)(n.A,{name:"api",link:"/osgl/api"}),(0,r.jsx)(n.A,{name:"github",link:"https://github.com/osgl-rbx/osgl/"})]})},9006:()=>{}}]);
//# sourceMappingURL=218.aa47bb56.chunk.js.map