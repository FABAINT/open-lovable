// Type declarations for ms module
declare module 'ms' {
  function ms(value: string): number;
  function ms(value: number): string;
  function ms(value: number, options: { long: true }): string;
  
  namespace ms {
    function parse(str: string): number;
    function format(ms: number, options?: { long?: boolean }): string;
  }
  
  export = ms;
}