--[[
     Utility script for Astro::Sunrise's astronomical documentation
     Copyright (C) 2017, 2019, 2021 Jean Forget

     This program is distributed under the same terms as Perl 5.16.3:
     GNU Public License version 1 or later and Perl Artistic License.

    Here is the summary of GPL:

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 1, or (at your option)
    any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software Foundation,
    Inc., https://www.fsf.org/.
]]

local substr = string.sub;
local floor  = math.floor;
local dq     = string.char(34); -- double-quote
local pedag  = 4; -- stretch factor for pedagogical purposes

function tim2x(tim)
  local hh = substr(tim, 1, 2);
  local mn = substr(tim, 4, 5);
  local ss = substr(tim, 7, 8);
  return floor(pedag * ((hh - 12) * 10 + mn / 6 + ss / 360));
end

function alt2y(alt)
  local sg = substr(alt, 1, 1);
  local dg = substr(alt, 2, 3);
  local mn = substr(alt, 5, 6);
  local ss = substr(alt, 8, 9);
  local sign;
  if sg == '-' then
    sign = -1;
  else
    sign =  1;
  end

  return sign * floor(dg + mn / 60 + ss / 3600);
end

function dessin(date, t)
  tex.print("\\begin{mplibcode}\n");
  tex.print("beginfig(1);\n");
  tex.print("draw (-120, 0) -- (120, 0);\n");
  tex.print("draw (0, -90) -- (0, 90);\n");

  -- extrema along the X-axis for the pseudo-analemma
  local x_min = 0;
  local x_max = 0;

  -- drawing the pseudo-analemma
  tex.print("draw ");
  for i, v in ipairs(t) do
    local x = tim2x(v.noon);
    local y = alt2y(v.alt12);
    if x < x_min then
      x_min = x;
    end;
    if x > x_max then
      x_max = x;
    end;
    tex.print("(" .. tostring(x) .. ", " .. tostring(y) .. ")..");
  end;
  tex.print("cycle;\n");
  x_min = tostring(x_min);
  x_max = tostring(x_max);

  -- parameters for the sine curve
  local a = 0;
  local b = 0;
  local x_noon = 0;

  -- labelling the pseudo-analemma
  for i, v in ipairs(t) do
    local x = tostring(tim2x(v.noon));
    local y = tostring(alt2y(v.alt12));
    if (v.date == date) then
      tex.print("dotlabel.rt(" .. dq .. dq .. ", (" .. x .. ", " .. y .. "));\n");
      if (substr(v.noon, 1, 2) == "11") then
        tex.print("label.ulft(" .. dq .. v.label .. dq .. ", (" .. x_min .. ", " .. y .. "));\n");
      else
        tex.print("label.urt(" .. dq .. v.label .. dq .. ", (" .. x_max .. ", " .. y .. "));\n");
      end;
      a = (alt2y(v.alt12) - alt2y(v.alt24)) /  2;
      b = (alt2y(v.alt12) + alt2y(v.alt24)) /  2;
      x_noon = tim2x(v.noon);
      break;
    end
  end

  -- drawing the sine curve
  tex.print("draw ");
  local y;
  for x = -120, 120, 5 do
    y = a * math.cos((x - x_noon) * math.pi / 120) + b;
    tex.print("(" .. tostring(x) .. ", " .. tostring(y) .. ")..");
  end
  -- ending the curve
  y = a * math.cos((120 - x_noon) * math.pi / 120) + b;
  tex.print("(120, " .. tostring(y) .. ");");

  tex.print("endfig;\n");
  tex.print("\\end{mplibcode}\n");
  tex.print("\\eject\n");
end

function dessingr(date)
  -- values obtained from Stellarium
  -- alt12 and alt24: not using the "degree" character U+00B0, because of encoding problems between lua and lualatex
  local t = {
       { date = "2017-01-21", noon = "12:11:24", alt12 = "+18 43 46", alt24 = "-58 25 33", label = "J" },
       { date = "2017-02-21", noon = "12:13:35", alt12 = "+28 08 20", alt24 = "-49 05 11", label = "F" },
       { date = "2017-03-21", noon = "12:07:08", alt12 = "+38 56 42", alt24 = "-38 17 49", label = "M" },
       { date = "2017-04-21", noon = "11:58:41", alt12 = "+50 32 27", alt24 = "-26 40 25", label = "A" },
       { date = "2017-05-21", noon = "11:56:38", alt12 = "+58 48 02", alt24 = "-18 20 44", label = "M" },
       { date = "2017-06-21", noon = "12:01:52", alt12 = "+61 57 27", alt24 = "-15 05 16", label = "J" },
       { date = "2017-07-21", noon = "12:06:28", alt12 = "+58 53 35", alt24 = "-18 03 18", label = "J" },
       { date = "2017-08-21", noon = "12:03:07", alt12 = "+50 28 12", alt24 = "-26 24 29", label = "A" },
       { date = "2017-09-21", noon = "11:53:02", alt12 = "+39 02 20", alt24 = "-37 48 40", label = "S" },
       { date = "2017-10-21", noon = "11:44:38", alt12 = "+27 39 33", alt24 = "-49 12 25", label = "O" },
       { date = "2017-11-21", noon = "11:45:58", alt12 = "+18 30 28", alt24 = "-58 25 33", label = "N" },
       { date = "2017-12-21", noon = "11:58:13", alt12 = "+15 04 59", alt24 = "-61 57 30", label = "D" },
      };
  dessin(date, t)
end

function dessinpl(date)
  -- values obtained from Stellarium
  -- latitude 76° 59'
  -- alt12 and alt24: not using the "degree" character U+00B0, because of encoding problems between lua and lualatex
  local t = {
       { date = "2017-01-21", noon = "12:11:24", alt12 = "-06 46 28", alt24 = "-32 41 38", label = "J" },
       { date = "2017-02-21", noon = "12:13:35", alt12 = "+02 37 58", alt24 = "-23 13 05", label = "F" },
       { date = "2017-03-21", noon = "12:07:08", alt12 = "+13 26 17", alt24 = "-12 23 52", label = "M" },
       { date = "2017-04-21", noon = "11:58:41", alt12 = "+25 01 58", alt24 = "-00 49 54", label = "A" },
       { date = "2017-05-21", noon = "11:56:38", alt12 = "+33 17 31", alt24 = "+07 21 27", label = "M" },
       { date = "2017-06-21", noon = "12:01:52", alt12 = "+36 26 55", alt24 = "+10 24 47", label = "J" },
       { date = "2017-07-21", noon = "12:06:28", alt12 = "+33 23 07", alt24 = "+07 15 10", label = "J" },
       { date = "2017-08-21", noon = "12:03:07", alt12 = "+24 57 48", alt24 = "-01 14 15", label = "A" },
       { date = "2017-09-21", noon = "11:53:02", alt12 = "+13 31 59", alt24 = "-12 41 40", label = "S" },
       { date = "2017-10-21", noon = "11:44:38", alt12 = "+02 09 15", alt24 = "-24 03 21", label = "O" },
       { date = "2017-11-21", noon = "11:45:58", alt12 = "-06 59 45", alt24 = "-33 08 13", label = "N" },
       { date = "2017-12-21", noon = "11:58:13", alt12 = "-10 25 13", alt24 = "-36 27 11", label = "D" },
      };
  dessin(date, t)
end
