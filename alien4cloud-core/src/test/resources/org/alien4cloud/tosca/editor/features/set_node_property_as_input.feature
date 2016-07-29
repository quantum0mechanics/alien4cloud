Feature: Topology editor: set node property as input

  Background:
    Given I am authenticated with "ADMIN" role
    And I upload CSAR from path "../../alien4cloud/target/it-artifacts/tosca-base-types-1.0.csar"
    And I upload CSAR from path "../../alien4cloud/target/it-artifacts/java-types-1.0.csar"
    And I create an empty topology template

  Scenario: Set a node property to an input that matches type should succeed.
    Given I execute the operation
      | type              | org.alien4cloud.tosca.editor.operations.nodetemplate.AddNodeOperation |
      | nodeName          | software_component                                                    |
      | indexedNodeTypeId | tosca.nodes.SoftwareComponent:1.0.0-SNAPSHOT                          |
    And I execute the operation
      | type                    | org.alien4cloud.tosca.editor.operations.inputs.AddInputOperation |
      | inputName               | Component version                                                |
      | propertyDefinition.type | version                                                          |
    When I execute the operation
      | type         | org.alien4cloud.tosca.editor.operations.nodetemplate.SetNodePropertyAsInputOperation |
      | nodeName     | software_component                                                                   |
      | propertyName | component_version                                                                    |
      | inputName    | Component version                                                                    |
    Then No exception should be thrown
    And The SPEL int expression "inputs.size()" should return 1
    And The SPEL expression "nodeTemplates['software_component'].properties['component_version'].function" should return "get_input"
    And The SPEL expression "nodeTemplates['software_component'].properties['component_version'].parameters" should return "Component version"

  Scenario: Set a node property to an input that does not match type should fail.
    Given I execute the operation
      | type              | org.alien4cloud.tosca.editor.operations.nodetemplate.AddNodeOperation |
      | nodeName          | software_component                                                    |
      | indexedNodeTypeId | tosca.nodes.SoftwareComponent:1.0.0-SNAPSHOT                          |
    And I execute the operation
      | type                    | org.alien4cloud.tosca.editor.operations.inputs.AddInputOperation |
      | inputName               | Component version                                                |
      | propertyDefinition.type | int                                                          |
    When I execute the operation
      | type         | org.alien4cloud.tosca.editor.operations.nodetemplate.SetNodePropertyAsInputOperation |
      | nodeName     | software_component                                                                   |
      | propertyName | component_version                                                                    |
      | inputName    | Component version                                                                    |
    Then an exception of type "alien4cloud.exception.NotFoundException" should be thrown
    And The SPEL expression "nodeTemplates['software_component'].properties['component_version']" should return null
