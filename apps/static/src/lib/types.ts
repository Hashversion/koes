import { Edge, Node, OnConnect, OnEdgesChange, OnNodesChange } from "@xyflow/react";

export interface MapNode extends Node {}
export interface MapEdge extends Edge {}

export interface MapState {
  nodes: MapNode[];
  edges: MapEdge[];
  onNodesChange: OnNodesChange;
  onEdgesChange: OnEdgesChange;
  onConnect: OnConnect;
}
