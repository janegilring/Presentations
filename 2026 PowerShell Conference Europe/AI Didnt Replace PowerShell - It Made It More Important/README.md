# AI Didn't Replace PowerShell — It Made It More Important

**PowerShell Conference Europe 2026** · Wiesbaden, Germany · June 4, 2026

## Slides

📄 [PSCONFEU26_JanEgilRing_AIDidntReplacePowerShell.pdf](./PSCONFEU26_JanEgilRing_AIDidntReplacePowerShell.pdf)

## Session Repository & Demo Code

All slide source, speaker notes, demo scripts, MCP server, infrastructure-as-code, and reference material live in a single companion repository:

- **Repository:** [janegilring/powershell-ai-skills-and-mcp](https://github.com/janegilring/powershell-ai-skills-and-mcp)
  - `presentation/` — reveal.js deck (`index.html`) with full speaker notes, narrative section files, and quote-verification artifacts.
  - `demos/skills-architecture/` — marketplace skill install, the custom-skill-creator workflow (`/create-skill`), and the bundled `infraops-triage` skill used on stage.
  - `demos/skill-demos/` — three skill-driven sub-demos: Pester, Azure Automation, and Sampler.
  - `demos/mcpserverps-infraops/` — local-then-Azure MCP demo using [MCPServerPS](https://www.powershellgallery.com/packages/MCPServerPS) plus a bare-bones plain-PowerShell MCP server (`BareBoneServer.ps1`) for "what is an MCP server, really?".
  - `containers/infraops-mcp/` — the production-shaped `InfraOps` PowerShell module exposed as an MCP server (direct VNet SSH + Arc SSH tunnel), packaged as a Linux container.
  - `infra/` — Bicep templates for the Azure deployment (VNet-integrated Container App, Key Vault, demo VMs, Arc role assignments).
  - `reference/` — talks, blog posts, and transcripts that shaped the narrative.

## Resources

- 🧠 [Anthropic Skills documentation](https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview) — model-agnostic packaging format that originated the "skill" abstraction used throughout this talk.
- 🛠 [GitHub Copilot custom skills](https://docs.github.com/en/copilot/concepts/agents/about-skills) — Copilot's implementation of the skills concept, used live on stage for the marketplace and custom-skill demos.
- 📜 [GitHub Awesome Copilot](https://github.com/github/awesome-copilot) — community-curated marketplace of skills, instructions, prompts, and chat modes referenced in the marketplace demo.
- 🧩 [Model Context Protocol (MCP) specification](https://modelcontextprotocol.io/) — the open protocol that lets agents discover and invoke tools, the backbone of the InfraOps demo.
- ⚙️ [MCPServerPS](https://www.powershellgallery.com/packages/MCPServerPS) (Justin Grote) — PowerShell module that turns any module into an MCP server with zero plumbing; the engine behind the InfraOps demo.
- 🧪 [PSMCP](https://github.com/dfinke/PSMCP) (Doug Finke) — alternative PowerShell-first MCP authoring module; mentioned as a peer to MCPServerPS.
- 🧰 [Sampler](https://github.com/gaelcolas/Sampler) — opinionated PowerShell module scaffold used by the Sampler skill demo.
- ✅ [Pester](https://pester.dev/) — the PowerShell testing framework powering the Pester skill demo.
- ☁️ [Azure Automation PowerShell runbooks](https://learn.microsoft.com/azure/automation/automation-runbook-types#powershell-runbooks) — used as the deployment target in the Azure Automation skill demo.
- 🚀 [Azure Container Apps](https://learn.microsoft.com/azure/container-apps/) — the hosting platform for the live `InfraOps` MCP server (VNet-integrated, IP allow-listed at ingress, managed-identity to Key Vault and Arc).
- 🌐 [Azure Arc-enabled servers](https://learn.microsoft.com/azure/azure-arc/servers/overview) + [SSH access via Microsoft.HybridConnectivity](https://learn.microsoft.com/azure/azure-arc/servers/ssh-arc-overview) — the second networking path the InfraOps tool reaches across, demonstrating "same tool, two transports".

## Abstract

PowerShell professionals are uniquely positioned for the agent era. The instinct that something doesn't smell right, the discipline of writing it down once so the next person (or the next agent) doesn't have to relearn it, the muscle memory of turning a one-off command into a parameterised function — that is exactly the discipline AI agents need to be useful in production.

This session is about three habits that compound when you bring them into an agent-assisted workflow:

1. **Skills** — capture the conversation you wish you didn't have to repeat, hand it to every future agent and every future teammate.
2. **MCP servers** — give agents real reach into the systems you operate, with PowerShell modules as the unit of capability and schemas as the security boundary.
3. **Knowing when to orchestrate vs. when to code** — the harness, not the model, is the differentiator.

Three live demos anchor the talk: installing and using community skills from a marketplace, creating a custom skill from scratch via a meta-skill, and calling a production-shaped PowerShell MCP server running in Azure that reaches both VNet-integrated VMs and Arc-enabled servers transparently. We close with the bigger frame: "It's not about the LLMs — it's about the harness."

This session is designed for PowerShell practitioners who want a pragmatic, opinionated playbook for working alongside AI agents without giving up the engineering discipline that made them good at PowerShell in the first place.

## Speaker

**Jan Egil Ring** — Sr. Cloud Solution Architect, Microsoft. [Speaker profile on Sessionize](https://sessionize.com/janegilring/).
