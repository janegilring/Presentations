# Beyond Scripts: Extending Azure SRE Agent with PowerShell Automation

**PowerShell Conference Europe 2026** · Wiesbaden, Germany

## Slides

📄 [PSCONFEU26_JanEgilRing_BeyondScripts.pdf](./PSCONFEU26_JanEgilRing_BeyondScripts.pdf)

## Sample Application & Demo Code

All demo scenarios are driven against a sample Azure application maintained in a dedicated repository:

- **Sample app & infrastructure:** [janegilring/sample-app-azure-sre](https://github.com/janegilring/sample-app-azure-sre) — Bicep infrastructure, sample web app, Azure Automation runbooks, drift detection, and the `Set-AppServicePlanSku` / `Check-InfrastructureDrift` PowerShell runbooks invoked by the custom SRE Agent sub-agents.

## Resources

- 📰 [Azure SRE Agent at Microsoft Build 2026: Bringing agentic operations to the enterprise](https://techcommunity.microsoft.com/blog/appsonazureblog/azure-sre-agent-at-microsoft-build-2026-bringing-agentic-operations-to-the-enter/4524669) — official announcement covering the platform's GA features, custom agents, MCP extensibility, incident handling, and enterprise governance.
- 📚 [Azure SRE Agent documentation](https://learn.microsoft.com/azure/sre-agent/) — overview, custom agents, memory, response plans, incident handlers.
- 🧩 [Model Context Protocol (MCP) specification](https://modelcontextprotocol.io/) — the open protocol used by SRE Agent to discover and invoke external tools.
- 🛠 [Azure Logic Apps Standard](https://learn.microsoft.com/azure/logic-apps/) — used in the demo to expose PowerShell-backed remediation tools (`ContosoSreRemediation_SetAppServicePlanSku`, `ContosoSreRemediation_EnrichIncident`) to SRE Agent via MCP.
- 🔁 [Azure Automation PowerShell runbooks](https://learn.microsoft.com/azure/automation/automation-runbook-types#powershell-runbooks) — PowerShell 7.x runbooks invoked from Logic Apps to perform the actual remediation (SKU scaling, drift remediation).
- 📡 [PowerShell Universal](https://docs.powershelluniversal.com/) — used in an extended demo as a second MCP server for exposing PowerShell-based API endpoints to SRE Agent.

## Abstract

Azure operations teams face a common challenge: repetitive incident response, alert triage, and infrastructure drift detection consume valuable time that could be spent on strategic initiatives. While PowerShell has long been the automation tool of choice for Azure administrators, the emergence of AI-powered agentic systems opens new possibilities for intelligent, autonomous operational workflows.

This session introduces Azure SRE Agent, Microsoft's AI-driven platform for site reliability engineering, and demonstrates how to extend it with PowerShell-based automation. You'll learn how SRE Agent uses Model Context Protocol (MCP) to integrate with external systems — and how you can leverage this capability to call PowerShell code in various ways such as via Azure Logic Apps and Azure Automation runbooks. We'll explore real-world scenarios including automated incident remediation, infrastructure drift detection, and proactive monitoring workflows that combine the intelligence of AI agents with the power and flexibility of PowerShell.

This session is designed for PowerShell practitioners with Azure experience who want to understand how AI agents can augment their automation workflows. You should be familiar with basic PowerShell scripting and have worked with Azure resources. We'll cover the fundamentals of Azure SRE Agent, its extensibility model, and practical integration patterns that let you bring your existing PowerShell expertise into the agentic automation world.

By the end of this session, you'll understand how to build custom sub-agents, connect SRE Agent to PowerShell-based workflows via MCP, and design hybrid automation solutions that leverage both traditional scripting and AI-driven decision-making. You'll leave with practical examples including: connecting to Azure Automation runbooks for complex orchestration, using Azure Logic Apps with inline PowerShell for rapid integration, calling APIs for custom business logic, and implementing continuous compliance checks that combine Azure Policy with PowerShell validation scripts.

## Speaker

**Jan Egil Ring** — Sr. Cloud Solution Architect, Microsoft. [Speaker profile on Sessionize](https://sessionize.com/janegilring/).
