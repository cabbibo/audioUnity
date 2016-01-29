float signedDistanceBox( float3 pos, float3 size ){

  float3 distance = abs(pos) - size;

  float maxDist = max( distance.x, max(distance.y,distance.z) );

  return min( maxDist , 0.0) + length(max(distance,0.0));

}