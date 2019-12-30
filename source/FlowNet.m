function [v1, v2] = FlowNet(rgb_map_path)
  load(rgb_map_path);
  flow_map = 20 * flow_map;
  v1 = flow_map(:,:,1);
  v2 = flow_map(:,:,2);
end
