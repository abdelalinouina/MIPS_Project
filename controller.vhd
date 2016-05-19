library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity controller is

generic (
WIDTH : positive := 32
);
port (
        rst,clk	: in std_logic;
        IR_5downto0out : in std_logic_vector(5 downto 0); 
        PCWriteCond: out std_logic;
        PCWrite: out std_logic;
        IorD :out std_logic;
        MemReadNotWrite: out std_logic;
        IRWrite: out std_logic;
        RegDst: out std_logic;
        MemToReg: out std_logic;
        regWrite: out std_logic;
        ALU_src_B: out std_logic_vector(1 downto 0);
        ALU_src_A: out std_logic;
        ALU_OP: out std_logic_vector(3 downto 0);
        PC_Source: out std_logic_vector(1 downto 0);
        PC_load_en: out std_logic);
        
end controller;

architecture BHV of controller is
begin
end BHV;