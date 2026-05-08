import { MapEdge, MapNode, MapState } from "@/lib/types";
import { addEdge, applyEdgeChanges, applyNodeChanges } from "@xyflow/react";
import { create } from "zustand";

const initialNodes: MapNode[] = [
  { id: "1", data: { label: "AWS" }, position: { x: 1, y: 1 } },
  { id: "2", data: { label: "Cloudflare" }, position: { x: 1, y: 200 } },
];

const initialEdges: MapEdge[] = [{ id: "e1-2", source: "1", target: "2" }];

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
