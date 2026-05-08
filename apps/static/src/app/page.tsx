import { Flow } from "@/components/flow";
import Image from "next/image";

export default function Home() {
  return (
    <>
      <header className="py-8">
        <div className="mx-auto max-w-300 px-3 lg:px-0">
          <div className="flex items-center justify-center gap-4">
            <Image
              src={"https://cdn.koes.site/brand/light-logo.png"}
              alt="light logo"
              width={36}
              height={36}
              loading="eager"
            />
            <h1 className="text-trim font-gehaks text-3xl font-medium">KOES</h1>
          </div>
        </div>
      </header>
      <section>
        <Flow />
      </section>
    </>
  );
}
