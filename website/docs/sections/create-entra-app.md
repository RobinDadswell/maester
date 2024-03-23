import GraphPermissions from '../sections/permissions.md';

### Create an Entra Application

- Open [Entra admin center](https://entra.microsoft.com) > **Identity** > **Applications** > **App registrations**
  - Tip: [enappreg.cmd.ms](https://enappreg.cmd.ms) is a shortcut to the App registrations page.
- Click **New registration**
- Enter a name for the application (e.g. `Maester DevOps Account`)
- Click **Register**

### Grant permissions to Microsoft Graph

- Open the application you created in the previous step
- Click **API permissions** > **Add a permission**
- Select **Microsoft Graph** > **Application permissions**
- Search for each of the permissions and check the box next to each permission:
  <GraphPermissions/>
- Click **Add permissions**
- Click **Grant admin consent for [your organization]**
- Click **Yes** to confirm