float3 calculateFieldNormalAtPosition( in float3 position ){

  // Take a tiny distance,
  // recalculate the field using this
  // change, and than normalize the 'derivative'
  // of the field
  float3 dVal = float3( 0.001, 0.0, 0.0 );

  float dX = map( position + dVal.xyy ).x - map( position - dVal.xyy ).x;
  float dY = map( position + dVal.yxy ).x - map( position - dVal.yxy ).x;
  float dZ = map( position + dVal.yyx ).x - map( position - dVal.yyx ).x;

  float3 normal = normalize( float3( dX , dY , dZ ) );

  return normalize( normal );

}