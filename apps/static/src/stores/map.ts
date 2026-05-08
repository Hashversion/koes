import { MapEdge, MapNode, MapState } from "@/lib/types";
import { addEdge, applyEdgeChanges, applyNodeChanges } from "@xyflow/react";
import { create } from "zustand";

const initialNodes: MapNode[] = [
  { id: "0", data: { label: "GitHub Actions" }, position: { x: -300, y: -200 }, type: "input" },
  { id: "1", data: { label: "AWS OIDC (main acc)" }, position: { x: -300, y: -80 } },
  { id: "2", data: { label: "AWS (static acc)" }, position: { x: -300, y: 30 } },
  { id: "3", data: { label: "S3 Bucket" }, position: { x: -300, y: 130 }, type: "output" },
];

const initialEdges: MapEdge[] = [
  {
    id: "e0-1",
    label: "assume role",
    source: "0",
    target: "1",
    markerEnd: { type: "arrow" },
  },
  {
    id: "e1-2",
    source: "1",
    target: "2",
    markerEnd: { type: "arrow" },
    label: "assume role",
  },
  { id: "e2-3", source: "2", target: "3", markerEnd: { type: "arrow" } },
];

export const useMapStore = create<MapState>((set) => ({
  nodes: initialNodes,
  edges: initialEdges,

  onNodesChange: (changes) =>
    set((state) => ({
      nodes: applyNodeChanges(changes, state.nodes),
    })),

  onEdgesChange: (changes) =>
    set((state) => ({
      edges: applyEdgeChanges(changes, state.edges),
    })),

  onConnect: (connection) =>
    set((state) => ({
      edges: addEdge(connection, state.edges),
    })),
}));
