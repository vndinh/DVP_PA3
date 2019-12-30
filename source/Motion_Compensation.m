function [psnr_rec, rec_fr] = Motion_Compensation(fr1, fr2, v1, v2, block_size)
  [height, width] = size(fr1);
  rec_fr = zeros(height, width);
  [m, n] = size(v1);
  for x2 = 1:height
    for x1 = 1:width
      id_x1 = floor((x1 - 1) / block_size) + 1;
      id_x1 = bound_cond(id_x1, n);
      id_x2 = floor((x2 - 1) / block_size) + 1;
      id_x2 = bound_cond(id_x2, m);
      
      % Find motion vector 1 at (x1, x2)
      mv1 = v1(id_x2, id_x1);
      mc1_x1 = floor(x1 + mv1);
      mc1_x1 = bound_cond(mc1_x1, width);
      mc2_x1 = ceil(x1 + mv1);
      mc2_x1 = bound_cond(mc2_x1, width);
      
      % Find motion vector 2 at (x1, x2)
      mv2 = v2(id_x2, id_x1);
      mc1_x2 = floor(x2 + mv2);
      mc1_x2 = bound_cond(mc1_x2, height);
      mc2_x2 = ceil(x2 + mv2);
      mc2_x2 = bound_cond(mc2_x2, height);
      
      % Determine intensity using bi-linear interpolation
      Y_11 = fr2(mc1_x2, mc1_x1);
      Y_12 = fr2(mc1_x2, mc2_x1);
      Y_21 = fr2(mc2_x2, mc1_x1);
      Y_22 = fr2(mc2_x2, mc2_x1);
      % Distance for interpolation
      mv1 = abs(floor(mv1) - mv1);
      mv2 = abs(floor(mv2) - mv2);
      Y1 = Y_11*(1-mv2) + Y_21*mv2;
      Y2 = Y_12*(1-mv2) + Y_22*mv2;
      Y = Y1*(1-mv1) + Y2*mv1;
      rec_fr(x2, x1) = Y;
    end
  end
  
  psnr_rec = psnr(rec_fr, fr1, 255);
end

function y = bound_cond(x, bound)
  if x < 1
    x = 1;
  elseif x > bound
    x = bound;
  end
  y = x;
end
