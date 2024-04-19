provider "zpa" {
  zpa_client_id         =  var.zpa_client_id
  zpa_client_secret     =  var.zpa_client_secret
  zpa_customer_id       =  var.zpa_customer_id 
}

// Create Application Segment for source client
resource "zpa_application_segment" "test_client" {
  name             = "test_client_access created by terraform"
  description      = "test_client_access created by terraform"
  enabled          = true
  health_reporting = "ON_ACCESS"
  bypass_type      = "NEVER"
  is_cname_enabled = true
  tcp_port_ranges   = ["3389", "3389"]
  udp_port_ranges   = ["3389", "3389"]
  domain_names     = ["source.internal.cloudapp.net"]
  segment_group_id = zpa_segment_group.test_client_app_group.id
  server_groups {
    id = [zpa_server_group.azure.id]
  }
}

// Create Server Group for source client
resource "zpa_server_group" "azure" {
  name              = "Servers Group for Azure created by terraform"
  description       = "Servers Group for Azure created by terraform"
  enabled           = true
  dynamic_discovery = true
  app_connector_groups {
    id = [data.zpa_app_connector_group.dc_connector_group.id]
  }
}

// Create Segment Group for source client
resource "zpa_segment_group" "test_client_app_group" {
  name            = "Test client App group created by terraform"
  description     = "Test client App group created by terraform"
  enabled         = true
}

resource "zpa_policy_access_rule" "access_policy_for_test_client" {
  name                          = "Test Client Access policy created by terraform"
  description                   = "Test Client Access policy created by terraform"
  action                        = "ALLOW"
  operator = "AND"
  policy_set_id = data.zpa_policy_type.access_policy.id

  conditions {
    negated = false
    operator = "OR"
    operands {
      name =  "Example"
      object_type = "APP_GROUP"
      lhs = "id"
      rhs = zpa_segment_group.test_client_app_group.id
    }
  }
}

// Create Application Segment for Target clients or apps
resource "zpa_application_segment" "target" {
  name             = "Target application created by terraform"
  description      = "Target application created by terraform"
  enabled          = true
  health_reporting = "ON_ACCESS"
  bypass_type      = "NEVER"
  is_cname_enabled = true
  tcp_port_ranges   = ["3389", "3389"]
  udp_port_ranges   = ["3389", "3389"]
  domain_names     = ["target.internal.cloudapp.net"]
  segment_group_id = zpa_segment_group.target_app_group.id
  server_groups {
    id = [zpa_server_group.azure.id]
  }
}

// Create Segment Group for source client
resource "zpa_segment_group" "target_app_group" {
  name            = "Target App group created by terraform"
  description     = "Target App group created by terraform"
  enabled         = true
}

resource "zpa_policy_access_rule" "access_policy_for_taget_app" {
  name                          = "Target App Access policy created by terraform"
  description                   = "Target App Access policy created by terraform"
  action                        = "ALLOW"
  operator = "AND"
  policy_set_id = data.zpa_policy_type.access_policy.id

  conditions {
    negated = false
    operator = "OR"
    operands {
      name =  "Example"
      object_type = "APP_GROUP"
      lhs = "id"
      rhs = zpa_segment_group.target_app_group.id
    }
  }
}

// Retrieve App Connector Group
data "zpa_app_connector_group" "dc_connector_group" {
  name = var.azure_ac_group
}

data "zpa_policy_type" "access_policy" {
    policy_type = "ACCESS_POLICY"
}