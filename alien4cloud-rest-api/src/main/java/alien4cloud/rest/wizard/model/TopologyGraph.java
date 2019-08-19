package alien4cloud.rest.wizard.model;

import lombok.Getter;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
public class TopologyGraph {
    private List<TopologyGraphNode> nodes;
    private List<TopologyGraphEdge> edges;
}