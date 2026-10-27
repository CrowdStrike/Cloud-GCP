# CrowdStrike Falcon for Antigravity

Connect Google Antigravity to the CrowdStrike Falcon platform through the official CrowdStrike MCP server. Your agent can triage detections, research threat intelligence, search Next-Gen SIEM, and work with hosts, vulnerabilities, cloud, and identity data in your Falcon tenant.

## What you can do

The CrowdStrike MCP server provides tools across many Falcon modules. For the current list of modules, tools, and example prompts, see the [module documentation](https://developer.crowdstrike.com/falcon-mcp/modules/overview/).

## Set up

1. Install the plugin from the Antigravity Marketplace.
2. Enable the plugin. Antigravity asks for the **Falcon MCP server URL**. Use the URL for your Falcon cloud:

   | Falcon cloud | MCP server URL |
   | --- | --- |
   | US-1 | `https://mcp.crowdstrike.com/v1` |
   | US-2 | `https://mcp.us-2.crowdstrike.com/v1` |
   | EU-1 | `https://mcp.eu-1.crowdstrike.com/v1` |

3. Open the plugin and select the **MCP** tab. The server shows **Setup required** until you sign in. Click **Authenticate**.
4. Sign in to Falcon in your browser and approve access.
5. Start a new conversation and try one of the suggested prompts.

## Troubleshooting

| Symptom | What to do |
| --- | --- |
| The server shows `Unauthorized` before you sign in | This is expected. Click **Authenticate**. |
| You cannot sign in to Falcon | Make sure that the server URL is for the same Falcon cloud as your Falcon console. |

## Support

Contact <cloud-integrations-alliances@crowdstrike.com>.

## License

MIT. See [LICENSE](LICENSE).
