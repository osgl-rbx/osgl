"use strict";(self.webpackChunkosgl_docs=self.webpackChunkosgl_docs||[]).push([[527],{282:()=>{},2355:()=>{},2987:(e,s,a)=>{a.d(s,{A:()=>o});var t=a(5043),n=a(579);const o=e=>{let{sections:s}=e;const[a,o]=(0,t.useState)({}),[r,l]=(0,t.useState)({}),[c,i]=(0,t.useState)(window.location.pathname+window.location.hash);(0,t.useEffect)((()=>{const e={};s.forEach((s=>{s.links.some((e=>c.startsWith(e.href)||c.startsWith(`#/${s.id}`)))&&(d(s.title),e[s.title]=!0)})),o(e);const a=()=>{const e=window.location.pathname+window.location.hash;i(e)};return window.addEventListener("popstate",a),()=>window.removeEventListener("popstate",a)}),[s]);const d=e=>{a[e]?(l((s=>({...s,[e]:"fade-out"}))),setTimeout((()=>{o((s=>({...s,[e]:!1}))),l((s=>({...s,[e]:""})))}),300)):(o((s=>({...s,[e]:!0}))),l((s=>({...s,[e]:"fade-in"}))))};return(0,n.jsx)("div",{className:"sidebar",children:s.map(((e,s)=>{const t=c.startsWith(`#/${e.id}`)||e.links.some((e=>c.startsWith(e.href)));return(0,n.jsxs)("div",{className:"sidebar-section",children:[(0,n.jsxs)("div",{className:"section-header",onClick:()=>d(e.title),children:[(0,n.jsx)("span",{style:{color:t?"#446EE4":"white"},children:e.title}),(0,n.jsx)("span",{className:"toggle-icon",style:{transform:a[e.title]?"rotate(90deg)":"rotate(0deg)"},children:"\u25b6"})]}),a[e.title]&&(0,n.jsx)("div",{className:`sub-sections ${r[e.title]}`,children:e.links.map(((e,s)=>{const a=c===e.href;return(0,n.jsx)("a",{href:e.href,className:"sub-section-link",style:{animationDelay:.1*s+"s",color:a?"#446EE4":"#c2c7d6"},children:e.text},s)}))})]},s)}))})}},4221:(e,s,a)=>{a.d(s,{A:()=>r});var t=a(5043),n=a(7709),o=(a(8806),a(9006),a(579));const r=e=>{let{code:s,language:r="lua",filename:l}=e;(0,t.useEffect)((()=>{n.A.registerLanguage("lua",a(6092))}),[]);const[c,i]=(0,t.useState)(!1),d=(0,t.useRef)(null);(0,t.useEffect)((()=>{d.current&&n.A.highlightElement(d.current)}),[s]);return(0,o.jsxs)("div",{className:"code-block-container",children:[l&&(0,o.jsx)("div",{className:"filename",children:(0,o.jsx)("p",{className:"doc-paragraph",children:l})}),(0,o.jsx)("pre",{className:"code-block",children:(0,o.jsx)("code",{ref:d,className:`language-${r}`,children:s})}),(0,o.jsx)("button",{className:"copy-btn "+(c?"copied":""),onClick:()=>{navigator.clipboard.writeText(s).then((()=>{i(!0),setTimeout((()=>i(!1)),1500)})).catch((e=>console.error("Copy failed:",e)))},children:c?"Copied!":"Copy"})]})}},4533:(e,s,a)=>{a.d(s,{A:()=>o});var t=a(5043),n=a(579);const o=e=>{let{src:s,alt:a="Image",className:o=""}=e;const[r,l]=(0,t.useState)(!1),[c,i]=(0,t.useState)(!1);(0,t.useEffect)((()=>{r?setTimeout((()=>i(!0)),10):i(!1)}),[r]),(0,t.useEffect)((()=>{const e=e=>{"Escape"===e.key&&d()};return document.addEventListener("keydown",e),()=>document.removeEventListener("keydown",e)}),[]);const d=()=>{i(!1),setTimeout((()=>l(!1)),300)};return(0,n.jsxs)(n.Fragment,{children:[(0,n.jsx)("img",{src:"/osgl"+s,alt:a,className:`image-thumbnail ${o}`,onClick:()=>l(!0)}),r&&(0,n.jsx)("div",{className:"image-overlay "+(c?"visible":""),onClick:d,children:(0,n.jsxs)("div",{className:"image-container "+(c?"visible":""),onClick:e=>e.stopPropagation(),children:[(0,n.jsx)("button",{className:"close-button",onClick:d,children:"\u2715"}),(0,n.jsx)("img",{src:"/osgl"+s,alt:a,className:"enlarged-image"})]})})]})}},5762:()=>{},6562:()=>{},7015:(e,s,a)=>{a.r(s),a.d(s,{default:()=>i});a(5043),a(9006);var t=a(929),n=a(8174),o=a(4221),r=(a(4533),a(2987)),l=(a(5762),a(6562),a(282),a(3371)),c=(a(2355),a(579));const i=()=>(0,c.jsxs)("div",{className:"Docs",children:[(0,c.jsx)("title",{children:"Docs | OSGL"}),(0,c.jsx)(n.A,{}),(0,c.jsx)("div",{className:"sidebar-content",children:(0,c.jsx)(r.A,{sections:l.A})}),(0,c.jsxs)("div",{className:"doc-content",children:[(0,c.jsx)("h1",{className:"doc-header",children:"Development environment"}),(0,c.jsx)("div",{className:"doc-header-line"}),(0,c.jsxs)("p",{className:"doc-paragraph",children:["In this chapter, we'll set up your environment for using OSGL. All of the tools we'll use, such as the ",(0,c.jsx)("code",{children:"image-converter"})," executable, are available on Windows and MacOS. You can also use the Roblox plugin provided in-studio for converting smaller images."]}),(0,c.jsxs)("p",{className:"doc-paragraph",children:["The most important component you'll need is the actual OSGL module itself. You can download the latest version of the module from either the ",(0,c.jsx)("a",{className:"doc-paragraph",href:"https://github.com/osgl-rbx/osgl/releases/latest",children:"Github releases"}),", the ",(0,c.jsx)("a",{className:"doc-paragraph",href:"https://create.roblox.com/store/asset/18468099737/OSGL",children:"Roblox marketplace"})," or the ",(0,c.jsx)("a",{className:"doc-paragraph",href:"https://wally.run/package/gunshotsoundstudios/osgl",children:"Wally Index"}),". "]}),(0,c.jsxs)("p",{className:"doc-paragraph",children:["You can use ",(0,c.jsx)("a",{className:"doc-paragraph",href:"https://rojo.space",children:"Rojo"})," to sync the ",(0,c.jsx)("code",{children:"Examples"})," folder to view any examples showcased or referenced in this tutorial. By default, all scripts have their ",(0,c.jsx)("code",{children:"Enabled"})," property set to ",(0,c.jsx)("code",{children:"false"}),", so you'll need to enable the script to test them. These scripts are designed to be self-sufficient and will automatically create any necessary resources during runtime. A good place to start is to try the example \"",(0,c.jsx)("b",{className:"doc-paragraph",children:"01-BlackScreen"}),'," which renders a black window.']}),(0,c.jsxs)("p",{className:"doc-paragraph",children:["To start, create a ",(0,c.jsx)("code",{children:"LocalScript"})," in your desired location (e.g., ",(0,c.jsx)("code",{children:"StarterPlayer/StarterPlayerScripts"}),"). Assuming the OSGL module has been placed in ",(0,c.jsx)("code",{children:"ReplicatedStorage"}),", paste the following code into your newly created script to test if OSGL works. Don't worry if you don't understand it yet! Upon running the game, there should be a black ",(0,c.jsx)("code",{children:"ImageLabel"})," in the center of your screen."]}),(0,c.jsx)(o.A,{code:'local Players = game:GetService("Players")\nlocal ReplicatedStorage = game:GetService("ReplicatedStorage")\n\nlocal OSGL = require(ReplicatedStorage.OSGL)\n\nlocal Window = OSGL.Window\nlocal color = OSGL.color\n\nlocal player = Players.LocalPlayer\nassert(player)\n\n-- Create instances needed\nlocal ScreenGui = Instance.new("ScreenGui")\nScreenGui.Name = "Screen"\nScreenGui.Parent = player.PlayerGui\n\nlocal Image = Instance.new("ImageLabel")\nImage.Name = "Texture"\nImage.Parent = ScreenGui\nImage.AnchorPoint = Vector2.new(.5, .5)\nImage.Position = UDim2.fromScale(.5, .5)\nImage.Size = UDim2.fromOffset(500, 500)\n\n-- Define window dimensions\nlocal WIDTH = 100\nlocal HEIGHT = 100\n\nlocal myWindow = Window.from(Image, WIDTH, HEIGHT)\n\nif not myWindow.isOk then\n\twarn("Encountered Error,", myWindow:UnwrapErr())\n    return\nend\n\nlocal unwrappedWindow: OSGL.Window = myWindow:Unwrap()\nunwrappedWindow:Clear(color.BLACK)\nunwrappedWindow:Render()'}),(0,c.jsx)("p",{className:"doc-paragraph",children:"If the code above executed successfully, you are now ready to proceed with the tutorial and the script can be deleted."}),(0,c.jsx)("div",{style:{height:"55px"}})]}),(0,c.jsx)(t.A,{}),(0,c.jsx)("div",{className:"grid-background-dark"})]})},8174:(e,s,a)=>{a.d(s,{A:()=>r});a(5043);var t=a(6214),n=a(5351),o=a(579);const r=()=>(0,o.jsxs)("div",{className:"topbar",style:{height:"55px",position:"fixed"},children:[(0,o.jsx)(n.A,{name:"logo",link:"/osgl"}),(0,o.jsx)("div",{className:"docs-sig",children:(0,o.jsx)("img",{src:"/osgl/docs-colour.png",alt:"docs",className:"docs-img"})}),(0,o.jsx)("img",{src:"/osgl/logo-sep.png",alt:"Separator",className:"seperator-img",style:{marginLeft:"75px"}}),(0,o.jsx)(t.A,{name:"api",link:"/osgl/#/api"}),(0,o.jsx)(t.A,{name:"github",link:"https://github.com/osgl-rbx/osgl/"})]})},9006:()=>{}}]);
//# sourceMappingURL=527.0b0da6d1.chunk.js.map