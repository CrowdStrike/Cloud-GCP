# CrowdStrike Falcon for Antigravity

Connect Google Antigravity to the CrowdStrike Falcon platform through the official CrowdStrike MCP server. Your agent can triage detections, research threat intelligence, search Next-Gen SIEM, and work with hosts, vulnerabilities, cloud, and identity data in your Falcon tenant.

CrowdStrike runs the MCP server, so there is nothing to install or host on your machine.

## What you can do

The CrowdStrike MCP server provides tools across many Falcon modules. For the current list of modules, tools, and example prompts, see the [module documentation](https://developer.crowdstrike.com/falcon-mcp/modules/overview/).

## Before you start

[Create a public (not confidential) MCP Client](https://docs.crowdstrike.com/r/en-US/g6auvcg3/cc726898) in your Falcon console, created with this redirect URI and save the client_id:

  ```text
  https://antigravity.google/oauth-callback
  ```

## Set up

1. Install the plugin from the Antigravity Marketplace.
2. Enable the plugin. Antigravity asks for these settings:

   | Setting | Value |
   | --- | --- |
   | Falcon MCP server URL | The URL for your Falcon cloud, from the table below |
   | Falcon MCP client ID | The client ID of the MCP client from "Before you start" |

   | Falcon cloud | Console URL | MCP server URL |
   | --- | --- | --- |
   | US-1 | `falcon.crowdstrike.com` | `https://mcp.crowdstrike.com/v1` |
   | US-2 | `falcon.us-2.crowdstrike.com` | `https://mcp.us-2.crowdstrike.com/v1` |
   | EU-1 | `falcon.eu-1.crowdstrike.com` | `https://mcp.eu-1.crowdstrike.com/v1` |

3. Open the plugin and select the **MCP** tab. The server shows **Setup required** until you sign in. Click **Authenticate**.
4. Sign in to Falcon in your browser and approve access.
5. Start a new conversation and try one of the suggested prompts.

## Troubleshooting

| Symptom | What to do |
| --- | --- |
| The server shows `Unauthorized` before you sign in | This is expected. Click **Authenticate**. |
| The browser shows `invalid client_id` | Check the client ID. The client must be in the same Falcon cloud as the server URL. |
| The browser shows `invalid_request` | Make sure that the MCP client has the redirect URI `https://antigravity.google/oauth-callback`. |

## Support

Contact <cloud-integrations-alliances@crowdstrike.com>.

## License

MIT. See [LICENSE](LICENSE).
