import commonjs from '@rollup/plugin-commonjs';
import nodeResolve from '@rollup/plugin-node-resolve';
import replace from '@rollup/plugin-replace'

export default {
  output: {},
  plugins: [
    nodeResolve({ preferBuiltins: true}), // or `true`
    commonjs(),
    replace({
      'process.env.NODE_ENV': JSON.stringify( 'production' )
    })
  ]
};
