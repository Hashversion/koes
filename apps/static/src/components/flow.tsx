"use client";

import { useMapStore } from "@/stores/map";
import { Background, Controls, MiniMap, ReactFlow } from "@xyflow/react";

export function Flow() {
  const { nodes, edges, onConnect, onEdgesChange, onNodesChange } = useMapStore();

  return (
    <section className="m-4">
      <div className="mx-auto h-[calc(100vh-132px)] w-full overflow-hidden rounded-[36] border border-neutral-800 bg-neutral-900 [corner-space:squircle]">
        <ReactFlow
          nodes={nodes}
          edges={edges}
          onNodesChange={onNodesChange}
          onEdgesChange={onEdgesChange}
          onConnect={onConnect}
          fitView
          fitViewOptions={{ maxZoom: 1, padding: 0.2 }}
          defaultEdgeOptions={{ animated: true }}
          colorMode="dark"
          proOptions={{ hideAttribution: true }}
        >
          <Background />
          <MiniMap />
          <Controls />
        </ReactFlow>
      </div>
    </section>
  );
}
