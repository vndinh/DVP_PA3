function [v1, v2] = Lucas_Kanade(fr0, fr1, block_size)
  [height, width] = size(fr0);
  
  d_x1 = imfilter(fr0, [-1,1]);
  d_x2 = imfilter(fr1, [-1;1]);
  d_t = fr1 - fr0;  % Partial derivative w.r.t time
  
  % Product of partial derivative
  d_x1x1 = d_x1 .* d_x1;
  d_x1x2 = d_x1 .* d_x2;
  d_x2x2 = d_x2 .* d_x2;
  d_x1t = d_x1 .* d_t;
  d_x2t = d_x2 .* d_t;
  
  % Sum of the product of partial derivative values in all blocks
  nb_x1 = floor(width/block_size);  % Number of blocks in the horizontal dimension
  nb_x2 = floor(height/block_size); % Number of blocks in the vertical dimension

  % Motion vectors
  v1 = zeros(nb_x2, nb_x1);
  v2 = zeros(nb_x2, nb_x1);
  
  for x2 = 1:nb_x2
    for x1 = 1:nb_x1
      id1_x2 = block_size * (x2 - 1) + 1;
      id2_x2 = block_size * x2;
      id1_x1 = block_size * (x1 - 1) + 1;
      id2_x1 = block_size * x1;
      
      a_x1x1 = sum(sum(d_x1x1(id1_x2:id2_x2, id1_x1:id2_x1)));
      a_x1x2 = sum(sum(d_x1x2(id1_x2:id2_x2, id1_x1:id2_x1)));
      a_x2x2 = sum(sum(d_x2x2(id1_x2:id2_x2, id1_x1:id2_x1)));
      A = [a_x1x1 a_x1x2; a_x1x2 a_x2x2];
      
      b_x1t = -sum(sum(d_x1t(id1_x2:id2_x2, id1_x1:id2_x1)));
      b_x2t = -sum(sum(d_x2t(id1_x2:id2_x2, id1_x1:id2_x1)));
      B = [b_x1t; b_x2t];
      
      V = A \ B;  % V = A^-1 * B
      v1(x2,x1) = V(1);
      v2(x2,x1) = V(2);
    end
  end
end

