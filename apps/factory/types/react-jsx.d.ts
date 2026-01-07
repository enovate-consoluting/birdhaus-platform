// Fix JSX component type conflicts with React 19
import * as React from 'react';

declare global {
  namespace JSX {
    interface Element extends React.ReactElement<unknown, string | React.JSXElementConstructor<unknown>> {}
  }
}

export {};
