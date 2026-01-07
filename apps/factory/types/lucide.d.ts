// Fix for lucide-react type conflicts with React 19
import type { SVGProps, RefAttributes, ForwardRefExoticComponent } from 'react';

declare module 'lucide-react' {
  export interface LucideProps extends Partial<SVGProps<SVGSVGElement>> {
    size?: string | number;
    absoluteStrokeWidth?: boolean;
  }

  export type LucideIcon = ForwardRefExoticComponent<
    Omit<LucideProps, 'ref'> & RefAttributes<SVGSVGElement>
  >;
}
