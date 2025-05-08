--!optimize 2

------------------------------------------------------------
-- OSGL v1.6.2 - Open-Source Graphical Library
-- Created/maintained by @saaawdust and contributors
--
-- Free to use, modify and distribute in your projects (including commercial games ;3)
-- Credit appreciated but not required
--
-- Do NOT:
-- - Repackage and sell OSGL directly
-- - Claim you created the core library
--
-- By using OSGL, you agree to these terms.
-- Full license available in the LICENSE file
------------------------------------------------------------

export type OSGLEditor = {
	["Background"]: Frame & {
		["BGScroller"]: ImageLabel & {
			["Top"]: UIGradient,
			["ScrollGradient"]: UIGradient,
		},
		["Frame"]: Frame & {
			["Side"]: UIGradient,
		},
	},
	["Screen"]: Frame & {
		["Topbar"]: Frame & {
			["Left"]: Frame & {
				["File"]: TextButton,
				["List"]: UIListLayout,
				["Padder"]: UIPadding,
				["Edit"]: TextButton,
			},
			["Centre"]: Frame & {
				["Name"]: TextLabel,
				["Meta"]: TextLabel,
				["List"]: UIListLayout,
				["Padder"]: UIPadding,
			},
			["List"]: UIListLayout,
			["End"]: Frame & {
				["List"]: UIListLayout,
				["Padder"]: UIPadding,
				["Close"]: TextButton,
			},
		},
		["View"]: Frame & {
			["Canvas"]: Frame & {
				["CanvasUnderlayer"]: ImageLabel,
				["Editable"]: ImageLabel,
			},
			["EditBar"]: Frame & {
				["UIListLayout"]: UIListLayout,
				["Pencil"]: Frame & {
					["Preview"]: Frame & {
						["Preview"]: ImageLabel,
					},
					["UIPadding"]: UIPadding,
					["UIListLayout"]: UIListLayout,
					["Pencil"]: Frame & {
						["Contents"]: Frame & {
							["Label"]: Frame & {
								["Object"]: ImageLabel,
								["UIPadding"]: UIPadding,
							},
							["Object"]: TextLabel,
							["UIPadding"]: UIPadding,
							["Selection"]: UIStroke,
							["UIListLayout"]: UIListLayout,
						},
						["State"]: TextButton,
					},
				},
				["UIPadding"]: UIPadding,
			},
			["UIPadding"]: UIPadding,
		},
	},
} & ScreenGui

export type OSGLFile = {
	width: number,
	height: number,
	buffer: buffer,
	name: string
}

return nil