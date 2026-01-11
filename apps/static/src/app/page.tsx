import { Button } from "@repo/ui/components/button";
import { Icons } from "@repo/ui/components/icons";

export default function Home() {
  return (
    <header className="py-8">
      <div className="mx-auto max-w-300 px-3 lg:px-0">
        <div className="flex items-center justify-center gap-4">
          <Icons.Logo className="size-8" />
          <h1 className="text-3xl font-semibold">KOES</h1>
        </div>
        <Button>it&apos;s nice</Button>
      </div>
    </header>
  );
}
